class Customer

  attr_reader :first_name,
              :last_name,
              :id,
              :created_at,
              :updated_at,
              :customer_repo_ref

  def initialize(input = {})
    @first_name = input[:first_name]
    @last_name = input[:last_name]
    @id = input[:id].to_i
    @created_at = input[:created_at]
    @updated_at = input[:updated_at]
    @customer_repo_ref = input[:customer_repo_ref]
  end

  def invoices
    customer_repo_ref.engine.invoice_repository.find_all_by_customer_id(self.id)
  end

  def transactions
    invoices = customer_repo_ref.engine.invoice_repository.find_all_by_customer_id(self.id)
    transactions = invoices.collect {|invoice| invoice.transactions}
    transactions.flatten
  end

  def favorite_merchant
    successful_transactions = transactions.select{|t| t.successful?} 
    invoices = successful_transactions.collect {|t| t.invoice}
    merchant_invoices_totals = invoices.each_with_object(Hash.new(0)) do |invoice,merch_total|
      merch_total[invoice.merchant_id] += 1
    end
    top_merchant_id = merchant_invoices_totals.sort_by{|_key,value| value}.reverse[0][0]
    customer_repo_ref.engine.merchant_repository.find_by_id(top_merchant_id) 
  end

end
