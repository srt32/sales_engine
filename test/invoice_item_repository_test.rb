require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/invoice_item_repository'

class InvoiceItemRepositoryTest < Minitest::Test
  
  def setup
    @iir = InvoiceItemRepository.new("./test/fixtures/invoice_items.csv",SalesEngine.new("./test/fixtures"))
    @dummy_date = Date.parse "Fri, 27 Mar 2012"
  end

  def test_it_populates_all_array_from_csv
    assert_equal 11, @iir.all.count
  end

  def test_it_populates_all_the_invoice_items_data
    invoice_items = @iir.all
    first_invoice_item = invoice_items[0]
    assert_equal 1, first_invoice_item.id 
    assert_equal 539, first_invoice_item.item_id
    assert_equal 1, first_invoice_item.invoice_id
    assert_equal "5", first_invoice_item.quantity
    assert_equal BigDecimal("136.35"), first_invoice_item.unit_price
    assert_equal @dummy_date, first_invoice_item.created_at 
    assert_equal @dummy_date, first_invoice_item.updated_at
  end

  def test_it_can_select_a_random_customer_from_all
    random_invoice_items = []
    5.times do
      random_invoice_items << @iir.random
    end
    refute_equal [nil,nil,nil,nil,nil], random_invoice_items
    refute_equal @iir.all, random_invoice_items
  end

  def test_it_returns_correct_single_invoice_item_by_attributes
    assert_equal 1, @iir.find_by_id("1").id 
    assert_equal 539,@iir.find_by_item_id("539").item_id
    assert_equal 1, @iir.find_by_invoice_id("1").invoice_id
    assert_equal "5", @iir.find_by_quantity("5").quantity
    assert_equal BigDecimal.new("136.35"), @iir.find_by_unit_price(BigDecimal.new("136.35")).unit_price
    assert_equal @dummy_date, @iir.find_by_created_at(@dummy_date).created_at 
    assert_equal @dummy_date, @iir.find_by_updated_at(@dummy_date).updated_at 
  end

  def test_it_returns_correct_count_of_merchants_by_all_attributes
    assert_equal 1, @iir.find_all_by_id("1").count
    assert_equal 1, @iir.find_all_by_item_id("539").count
    assert_equal 6, @iir.find_all_by_invoice_id("1").count
    assert_equal 2, @iir.find_all_by_quantity("5").count
    assert_equal 1, @iir.find_all_by_unit_price(BigDecimal.new("136.35")).count
    assert_equal 10, @iir.find_all_by_created_at(@dummy_date).count 
    assert_equal 10, @iir.find_all_by_updated_at(@dummy_date).count  
  end

  def test_it_returns_empty_array_for_all_item_id_when_no_results
    ii = @iir.find_all_by_item_id("99")
    assert_equal [], ii
  end

  def test_it_returns_associated_invoice_given_ii
    ii = @iir.find_by_id(5)
    ii_invoice = ii.invoice
    assert_kind_of Invoice, ii_invoice
    assert_equal 26, ii_invoice.merchant_id
  end

  def test_it_returns_associated_item_given_ii
    ii = @iir.find_by_id(5)
    ii_item = ii.item
    assert_kind_of Item, ii_item
    assert_equal "Item Nemo Facere", ii_item.name
  end

  def test_it_can_return_a_sorted_array_of_total_sold
    totals_sold = @iir.total_quantity_sold
    assert_kind_of Array, totals_sold
    assert_equal [1,15], totals_sold[0]
  end

end
