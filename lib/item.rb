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
    @id = input[:id]
    @name = input[:name]
    @description = input[:description]
    @unit_price = input[:unit_price]
    @merchant_id = input[:merchant_id]
    @created_at = input[:created_at]
    @updated_at = input[:updated_at]
    @item_repo_ref = input[:item_repo_ref]
  end

  def invoice_items
    item_repo_ref.engine.invoice_item_repository.find_all_by_item_id(self.id) 
  end

end
