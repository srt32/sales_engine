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
    @id = input[:id]
    @created_at = input[:created_at]
    @updated_at = input[:updated_at]
    @customer_repo_ref = input[:customer_repo_ref]
  end

  def invoices
    customer_repo_ref.engine.invoice_repository.find_all_by_customer_id(self.id)
  end

end
