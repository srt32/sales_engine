class InvoiceItem

  attr_reader :id,
              :item_id,
              :invoice_id,
              :quantity,
              :unit_price,
              :created_at,
              :updated_at,
              :invoice_item_repo_ref

  def initialize(input = {})
    @id = input[:id]
    @item_id = input[:item_id]
    @invoice_id = input[:invoice_id]
    @quantity = input[:quantity]
    @unit_price = input[:unit_price]
    @created_at = input[:created_at]
    @updated_at = input[:updated_at]
    @invoice_item_repo_ref = input[:invoice_item_repo_ref]
  end

  def invoice
    ir = invoice_item_repo_ref.engine.invoice_repository
    ir.find_by_id(self.invoice_id)
  end

end
