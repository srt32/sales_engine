class Transaction
  
  attr_reader :id, 
              :invoice_id, 
              :credit_card_number, 
              :result,
              :created_at, 
              :updated_at,
              :transaction_repo_ref

  def initialize(input={})
    @id = input[:id].to_i
    @invoice_id = input[:invoice_id]
    @credit_card_number = input[:credit_card_number]
    @result = input[:result]
    @created_at = input[:created_at]
    @updated_at = input[:updated_at]
    @transaction_repo_ref = input[:transaction_repo_ref]
  end

  def invoice
    invoice_repo = transaction_repo_ref.engine.invoice_repository
    invoice_repo.find_by_id(self.invoice_id)
  end

end
