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

  def test_it_calculates_revenue_for_item_with_a_successful_invoice
    # need to find an invoice_item with a succesful charge. id = 1 works
    assert non-zero, item.revenue
    # need to find an invoice_item withOUT a successful charge. 
    #   need to make a new one, id = 8, with invoice_id = 11
    #     Should look like, "8,530,11,4,66747,2012-03-27 14:54:09 UTC,2012-03-27
    #     14:54:09 UTC"
    assert 0, item.revenue
    # Implementation, Revenue method => 
    # if invoice_item.invoice.successful_charge?
    #  revenue = quantity * unit_price
    # else
    #  revenue = 0
    # end
    # THEN, make a method on INVOICE, total_revenues, that goes through
    # invoice.invoice_items and sums up invoice_item.revenue
    # THEN, go sort them and return the merchatn object.
     
  end

end
