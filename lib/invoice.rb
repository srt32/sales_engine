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
    @created_at ||= DateTime.strptime(@created_at_raw,"%Y-%m-%d %H:%M:%S").to_date
  end

  def updated_at
    @updated_at ||= DateTime.strptime(@created_at_raw,"%Y-%m-%d %H:%M:%S").to_date
  end

  def transactions
   tr = invoice_repo_ref.engine.transaction_repository
   tr.find_all_by_invoice_id(self.id)
  end

  def invoice_items
    iir = invoice_repo_ref.engine.invoice_item_repository
    iir.find_all_by_invoice_id(self.id)
  end

  def items
    iir = invoice_repo_ref.engine.invoice_item_repository
    invoice_items = iir.find_all_by_invoice_id(self.id)
    items = []
    invoice_items.each do |ii|
      item = invoice_repo_ref.engine.item_repository.find_by_id(ii.item_id)
      items << item unless item.nil?
    end
    return items
  end

  def customer
    cr = invoice_repo_ref.engine.customer_repository
    cr.find_by_id(self.customer_id)
  end

  def merchant
    mr = invoice_repo_ref.engine.merchant_repository
    mr.find_by_id(self.merchant_id)
  end

  def successful_charge?
    self.transactions.any?{|t| t.successful?}
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
    #get quantity for each item on the new invoice
    invoice_items_to_create = related_items.each_with_object(Hash.new(0)) do |item,quantities|
      quantities[item.id] += 1
    end
    
    invoice_items_to_create.each do |item|
      invoice_item_create_hash = {:id => invoice_item_repo.all.max_by{|ii| ii.id}.id + 1,
                                  :item_id => item[0],
                                  :quantity => item[1],
                                  :unit_price => "100",
                                  :invoice_item_repo_re => invoice_item_repo}
      invoice_item_repo.create(invoice_item_create_hash)
    end
  end

end
