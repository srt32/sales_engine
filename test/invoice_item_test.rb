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
    assert_equal created_at_date, @successful_ii.created_at
    assert_equal updated_at_date, @successful_ii.updated_at
    assert_kind_of InvoiceItemRepository, @successful_ii.invoice_item_repo_ref
  end

  def created_at_date
    DateTime.strptime("2012-03-27 14:54:09 UTC","%Y-%m-%d %H:%M:%S").to_date
  end

  def updated_at_date
     DateTime.strptime("2012-03-27 14:54:10 UTC","%Y-%m-%d %H:%M:%S").to_date 
  end

  def test_it_calculates_revenue_for_item_with_a_successful_invoice
    assert_equal 16000, @successful_ii.revenue
    assert_equal 0, @failed_ii.revenue    
  end

  def test_it_returns_true_when_sent_successful_charge_on_good_ii
    assert @successful_ii.successful_charge?
  end

  def test_it_returns_false_when_sent_successful_charge_on_bad_ii
    refute @failed_ii.successful_charge?
  end

end
