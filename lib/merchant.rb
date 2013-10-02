#require 'pry'
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
    ir = merchant_repo_ref.engine.item_repository    
    ir.find_all_by_merchant_id(self.id)
  end

  def invoices
    ir = merchant_repo_ref.engine.invoice_repository
    ir.find_all_by_merchant_id(self.id)
  end

  def revenue(date = "")
    invoice_items = self.items.map {|item| item.invoice_items}
    invoice_items_within_range = invoice_items.flatten.select{|ii| date == "" ? true : ii.invoice.created_at == date}
    total_revenue = invoice_items_within_range.reduce(0) {|sum,invoice_item| sum + invoice_item.revenue}
  end

  def favorite_customer
    successful_invoices = invoices.select{|i| i.successful_charge?}
    customer_invoice_totals = successful_invoices.each_with_object(Hash.new(0)) do |invoice,cust_total|
      cust_total[invoice.customer_id] += 1
    end
    top_customer_id = customer_invoice_totals.sort_by{|_key,value| value}.reverse[0][0]
    merchant_repo_ref.engine.customer_repository.find_by_id(top_customer_id)
  end

  def customers_with_pending_invoices
    outstanding_invoices = invoices.reject{|i| i.successful_charge?}
    delinquent_customer_ids = outstanding_invoices.collect{|invoice| invoice.customer_id}
    delinquent_customers = delinquent_customer_ids.collect{|c_id| merchant_repo_ref.engine.customer_repository.find_by_id(c_id)}
  end

  def items_successfully_sold
    invoices.reduce(0){|sum,invoice| sum += invoice.quantity_of_items}
  end

end
