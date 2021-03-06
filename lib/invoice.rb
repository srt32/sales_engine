class Invoice
  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at,
              :invoice_repo_ref

  def initialize(input = {})
    @id = input[:id].to_i
    @customer_id = input[:customer_id].to_i
    @merchant_id = input[:merchant_id].to_i
    @status = input[:status]
    @created_at_raw = input[:created_at]
    @updated_at_raw = input[:updated_at]
    @invoice_repo_ref = input[:invoice_repo_ref]
  end

  def created_at
    @created_at ||= DateTime.parse(@created_at_raw.to_s).to_date
  end

  def updated_at
    @updated_at ||= DateTime.strptime(@updated_at_raw,"%Y-%m-%d %H:%M:%S").to_date
  end

  def transaction_repository
    invoice_repo_ref.engine.transaction_repository
  end

  def invoice_item_repository
    invoice_repo_ref.engine.invoice_item_repository
  end

  def invoice_repository
    invoice_repo_ref.engine.invoice_repository
  end

  def transactions
   transaction_repository.find_all_by_invoice_id(id)
  end

  def invoice_items
   invoice_item_repository.find_all_by_invoice_id(id)
  end

  def items
    items = invoice_item_repository.find_all_by_invoice_id(id).map do |ii|
      invoice_repo_ref.engine.item_repository.find_by_id(ii.item_id)
    end.reject(&:nil?)
  end

  def customer
    invoice_repo_ref.engine.customer_repository.find_by_id(customer_id)
  end

  def merchant
    invoice_repo_ref.engine.merchant_repository.find_by_id(merchant_id)
  end

  def successful_charge?
    self.transactions.any?(&:successful?)
  end

  def invoice_revenue
    self.invoice_items.reduce(0){|result,ii| ii.revenue + result}
  end

  def quantity_of_items
    if successful_charge?
      invoice_items.reduce(0){|quantity,ii| quantity + ii.num_items}
    else
      0
    end
  end

  def invoice_item_repo
    invoice_repo_ref.engine.invoice_item_repository
  end

  def create_related_invoice_items(related_items)
    invoice_items_to_create(related_items).each do |item|
      invoice_item_repo.create(invoice_item_create_hash(item))
    end
  end

  def invoice_item_create_hash(item)
     {:id => invoice_item_repo.all.max_by{|ii| ii.id}.id + 1,
                                  :item_id => item[0],
                                  :invoice_id => id,
                                  :quantity => item[1],
                                  :unit_price => "100",
                                  :invoice_item_repo_ref => invoice_item_repo}
  end

  def invoice_items_to_create(related_items)
     related_items.each_with_object(Hash.new(0)) do |item,quantities|
      quantities[item.id] += 1
    end
  end

  def charge(input)
    transaction_repository.create(transaction_create_hash(input))
  end

  def transaction_create_hash(input)
    new_id = invoice_repository.all.max_by{|inv| inv.id}.id + 1
    {:id => new_id,
     :invoice_id => self.id,
     :credit_card_number => input[:credit_card_number],
     :result => input[:result],
     :created_at => Time.now.to_date,
     :updated_at => Time.now.to_date,
     :transaction_repo_ref => invoice_repo_ref.engine.transaction_repository}
  end

end
