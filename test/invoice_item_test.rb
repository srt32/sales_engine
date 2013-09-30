require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/invoice_item'

class InvoiceItemTest < MiniTest::Test

  def setup
    @successful_ii =  InvoiceItem.new(:id => "1",
                            :item_id => "100",
                            :invoice_id => "1",
                            :quantity => "4",
                            :unit_price => "4000",
                            :created_at => "2012-03-27 14:54:09 UTC",
                            :updated_at => "2012-03-27 14:54:10 UTC",
                            :invoice_item_repo_ref => InvoiceItemRepository.new("./test/fixtures/invoice_items.csv",SalesEngine.new("./test/fixtures")))
    @failed_ii = InvoiceItem.new(:id => "8",
                               :item_id => "530",
                               :invoice_id => "11",
                               :quantity => "4",
                               :unit_price => "66747",
                               :created_at => "2012-03-27 14:54:09 UTC",
                               :updated_at => "2012-03-27 14:54:09 UTC",
                               :invoice_item_repo_ref => InvoiceItemRepository.new("./test/fixtures/invoice_items.csv", SalesEngine.new("./test/fixtures")))
   end

  def test_it_can_be_given_all_its_attributes
    assert_equal 1, @successful_ii.id
    assert_equal 100, @successful_ii.item_id
    assert_equal 1, @successful_ii.invoice_id
    assert_equal "4", @successful_ii.quantity
    assert_equal "4000", @successful_ii.unit_price
    assert_equal "2012-03-27 14:54:09 UTC", @successful_ii.created_at
    assert_equal "2012-03-27 14:54:10 UTC", @successful_ii.updated_at
    assert_kind_of InvoiceItemRepository, @successful_ii.invoice_item_repo_ref
  end

  def test_it_calculates_revenue_for_item_with_a_successful_invoice
    assert_equal 16000, @successful_ii.revenue
    assert_equal 0, @failed_ii.revenue    
  end

end
