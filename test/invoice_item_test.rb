require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/invoice_item'

class InvoiceItemTest < MiniTest::Test

  def setup
    @ii = InvoiceItem.new
  end

  def test_it_can_be_given_all_its_attributes
    item = InvoiceItem.new(:id => "1",
                            :item_id => "100",
                            :invoice_id => "99",
                            :quantity => "4",
                            :unit_price => "4000",
                            :created_at => "2012-03-27 14:54:09 UTC",
                            :updated_at => "2012-03-27 14:54:10 UTC",
                            :invoice_item_repo_ref => InvoiceItemRepository.new("./test/fixtures/invoice_items.csv",SalesEngine.new))
    assert_equal 1, item.id
    assert_equal 100, item.item_id
    assert_equal 99, item.invoice_id
    assert_equal "4", item.quantity
    assert_equal "4000", item.unit_price
    assert_equal "2012-03-27 14:54:09 UTC", item.created_at
    assert_equal "2012-03-27 14:54:10 UTC", item.updated_at
    assert_kind_of InvoiceItemRepository, item.invoice_item_repo_ref
  end

end
