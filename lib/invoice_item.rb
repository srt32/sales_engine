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
    invoice_item_repo_ref.engine.invoice_repository.find_by_id(self.invoice_id)
  end

  def item
    invoice_item_repo_ref.engine.item_repository.find_by_id(self.item_id)
  end

  def revenue
    invoice.successful_charge? ? quantity.to_i * unit_price : 0
  end

  def successful_charge?
    invoice.successful_charge?
  end

  def num_items
    quantity.to_i 
  end

 end
