class Invoice
  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at,
              :invoice_repo_ref

  def initialize(input = {})
    @id = input[:id]
    @customer_id = input[:customer_id]
    @merchant_id = input[:merchant_id]
    @status = input[:status]
    @created_at = input[:created_at]
    @updated_at = input[:updated_at]
    @invoice_repo_ref = input[:invoice_repo_ref]
  end

  def transactions
   tr = invoice_repo_ref.engine.transaction_repository
   tr.find_all_by_invoice_id(self.id)
  end

  def invoice_items
    iir = invoice_repo_ref.engine.invoice_item_repository
    iir.find_all_by_invoice_id(self.id)
  end

end
