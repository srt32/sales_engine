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
    @id = input[:id].to_i
    @item_id = input[:item_id].to_i
    @invoice_id = input[:invoice_id].to_i
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

  def item
    item_repo = invoice_item_repo_ref.engine.item_repository
    item_repo.find_by_id(self.item_id)
  end

  def revenue
    if self.invoice.successful_charge?
      revenue = self.quantity.to_i * self.unit_price.to_i
    else
      revenue = 0
    end
  end

end
