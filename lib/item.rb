require 'csv'

class Item

  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :merchant_id,
              :created_at,
              :updated_at,
              :item_repo_ref

  def initialize(input)
    @id = input[:id].to_i
    @name = input[:name]
    @description = input[:description]
    @unit_price = convert_cents_string_into_big_decimal(input[:unit_price])
    @merchant_id = input[:merchant_id].to_i
    @created_at = input[:created_at]
    @updated_at = input[:updated_at]
    @item_repo_ref = input[:item_repo_ref]
  end

  def convert_cents_string_into_big_decimal(input_string)
    BigDecimal.new((input_string.to_i/100.0).to_s)
  end

  def invoice_items
    item_repo_ref.engine.invoice_item_repository.find_all_by_item_id(self.id) 
  end

  def merchant
    item_repo_ref.engine.merchant_repository.find_by_id(self.merchant_id)
  end

end
