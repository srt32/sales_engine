class Merchant

  attr_reader :id,
              :name,
              :created_at,
              :updated_at,
              :merchant_repo_ref

  def initialize(input = {})
    @id = input[:id].to_i
    @name = input[:name]
    @created_at = input[:created_at]
    @updated_at = input[:updated_at]
    @merchant_repo_ref = input[:merchant_repo_ref]
  end

  def items
    merchant_repo_ref.engine.item_repository.find_all_by_merchant_id(id)
  end

  def invoices
    merchant_repo_ref.engine.invoice_repository.find_all_by_merchant_id(id)
  end

  def revenue(date = "")
    invoice_items_within_range(date).reduce(0) do |sum,invoice_item| 
      sum + invoice_item.revenue
    end
  end

  def invoice_items_within_range(date)
    invoice_items.flatten.select do 
      |ii| date == "" ? true : ii.invoice.created_at == date
    end
  end

  def invoice_items
    items.map(&:invoice_items)
  end

  def favorite_customer
    customer_repository.find_by_id(top_customer_id)
  end

  def top_customer_id
    successful_invoices.each_with_object(Hash.new(0)) do |invoice,cust_total|
      cust_total[invoice.customer_id] += 1
    end.sort_by{|_key,value| value}.reverse[0][0]
  end

  def successful_invoices
    invoices.select(&:successful_charge?)
  end

  def customers_with_pending_invoices
    delinquent_customer_ids.collect{|c_id| customer_repository.find_by_id(c_id)}
  end

  def delinquent_customer_ids
    outstanding_invoices.collect(&:customer_id)
  end

  def outstanding_invoices
     invoices.reject(&:successful_charge?)
  end

  def items_successfully_sold
    invoices.reduce(0){|sum,invoice| sum += invoice.quantity_of_items}
  end

  def customer_repository
    merchant_repo_ref.engine.customer_repository
  end
end
