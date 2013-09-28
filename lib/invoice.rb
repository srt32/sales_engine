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

end
