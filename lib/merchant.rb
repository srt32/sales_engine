class Merchant

  attr_reader :id,
              :name,
              :created_at,
              :updated_at,
              :merchant_repo_ref

  def initialize(input = {})
    @id = input[:id].to_i
    @name = input[:name]
    @created_at = input[:created_at]
    @updated_at = input[:updated_at]
    @merchant_repo_ref = input[:merchant_repo_ref]
  end

  def items
    ir = merchant_repo_ref.engine.item_repository    
    ir.find_all_by_merchant_id(self.id)
  end

  def invoices
    ir = merchant_repo_ref.engine.invoice_repository
    ir.find_all_by_merchant_id(self.id)
  end

  def revenue
    invoice_items = self.items.map {|item| item.invoice_items}
    total_revenue = invoice_items.flatten.reduce(0) {|sum,invoice_item| sum + invoice_item.revenue}
  end

end
