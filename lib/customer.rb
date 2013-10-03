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

  def invoice_repository
    customer_repo_ref.engine.invoice_repository
  end

  def invoices
   invoice_repository.find_all_by_customer_id(id)
  end

  def transactions
    invoices = invoice_repository.find_all_by_customer_id(id)
    invoices.collect(&:transactions).flatten
  end

  def favorite_merchant
    invoices = transactions.select(&:successful?).collect(&:invoice)
    merchant_invoices_totals = invoices.each_with_object(Hash.new(0)) do |invoice,merch_total|
      merch_total[invoice.merchant_id] += 1
    end
    top_merchant_id = merchant_invoices_totals.sort_by{|_key,value| value}.reverse[0][0]
    customer_repo_ref.engine.merchant_repository.find_by_id(top_merchant_id) 
  end

end
