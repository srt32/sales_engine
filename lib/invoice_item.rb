class InvoiceItem

  attr_reader :id,
              :item_id,
              :invoice_id,
              :quantity,
              :unit_price,
              :invoice_item_repo_ref

  def initialize(input = {})
    @id = input[:id].to_i
    @item_id = input[:item_id].to_i
    @invoice_id = input[:invoice_id].to_i
    @quantity = input[:quantity]
    @unit_price = convert_cents_string_into_big_decimal(input[:unit_price])
    @created_at_raw = input[:created_at]
    @updated_at_raw = input[:updated_at]
    @invoice_item_repo_ref = input[:invoice_item_repo_ref]
  end

  def convert_cents_string_into_big_decimal(input_string)
    BigDecimal.new((input_string.to_i/100.0).to_s)
  end

  def created_at
    @created_at ||= DateTime.strptime(@created_at_raw,"%Y-%m-%d %H:%M:%S").to_date
  end

  def updated_at
    @updated_at ||= DateTime.strptime(@created_at_raw,"%Y-%m-%d %H:%M:%S").to_date
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
      self.quantity.to_i * self.unit_price
    else
      BigDecimal.new("0.00")
    end
  end

  def successful_charge?
    self.invoice.successful_charge?
  end

  def num_items
    quantity.to_i 
  end

 end
