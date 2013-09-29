require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/invoice_repository'

class InvoiceRepositoryTest < MiniTest::Test 

  def setup
    @instance = InvoiceRepository.new("./test/fixtures/invoices.csv",SalesEngine.new("./test/fixtures"))
  end

  def test_it_is_initialized_with_a_filepath
    assert_equal "./test/fixtures/invoices.csv", @instance.file_path
  end

  def test_it_has_information_in_array_from_csv
    assert_equal 10, @instance.all.count
  end

  def test_it_gathers_all_invoice_data
    first_invoice = (@instance.all)[0]
    assert_equal 1, first_invoice.id
    assert_equal 1, first_invoice.customer_id
    assert_equal 26, first_invoice.merchant_id
    assert_equal "shipped", first_invoice.status
    assert_equal "2012-03-25 09:54:09 UTC", first_invoice.created_at
    assert_equal "2012-03-25 09:54:09 UTC", first_invoice.updated_at
  end

  def test_it_can_select_random_invoice
    random_invoices = []
    5.times do
      random_invoices << @instance.random
    end
    refute_equal [nil,nil,nil,nil,nil], random_invoices
    refute_equal @instance.all, random_invoices
  end

  def test_it_returns_correct_value_for_find_method
    assert_equal 1, @instance.find_by_id("1").id
    assert_equal 1, @instance.find_by_customer_id("1").customer_id
    assert_equal 26, @instance.find_by_merchant_id("26").merchant_id
    assert_equal "shipped", @instance.find_by_status("shipped").status
    assert_equal "2012-03-25 09:54:09 UTC", @instance.find_by_created_at("2012-03-25 09:54:09 UTC").created_at
    assert_equal "2012-03-25 09:54:09 UTC", @instance.find_by_updated_at("2012-03-25 09:54:09 UTC").updated_at
  end

  def test_it_returns_correct_value_for_find_by_id_given_integer_input
    assert_equal 1, @instance.find_by_id(1).id
  end

  def test_it_returns_correct_value_for_all_find_method
    assert_equal 1, @instance.find_all_by_id("1").count
    assert_equal 8, @instance.find_all_by_customer_id("1").count
    assert_equal 1, @instance.find_all_by_merchant_id("26").count
    assert_equal 10, @instance.find_all_by_status("shipped").count
    assert_equal 1, @instance.find_all_by_created_at("2012-03-25 09:54:09 UTC").count
    assert_equal 1, @instance.find_all_by_updated_at("2012-03-25 09:54:09 UTC").count
  end

  def test_it_returns_transaction_collection_given_an_invoice
    first_invoice = @instance.find_by_id("1")                       
    first_invoice_transactions = first_invoice.transactions
    assert_equal 2, first_invoice_transactions.count
    assert_equal "4654405418249632", first_invoice_transactions[0].credit_card_number
  end

  def test_it_returns_invoice_items_collection_given_an_invoice
    first_invoice = @instance.find_by_id("1")
    first_invoice_invoice_items = first_invoice.invoice_items
    assert_equal 7, first_invoice_invoice_items.count
    assert_equal "13635", first_invoice_invoice_items[0].unit_price
  end

  def test_it_returns_items_collection_through_InvoiceItems_given_an_invoice
    first_invoice = @instance.find_by_id(1)
    first_invoice_items = first_invoice.items
    assert_equal 4,first_invoice_items.count
    assert_equal "Item Ea Voluptatum", first_invoice_items[0].name
  end

  def test_it_returns_customer_instance_given_an_invoice
    first_invoice = @instance.find_by_id(1)
    first_invoice_customer = first_invoice.customer
    assert_kind_of Customer, first_invoice_customer
    assert_equal "Joey", first_invoice_customer.first_name
  end

  def test_it_returns_merchant_instance_given_an_invoice
    first_invoice = @instance.find_by_id(2)
    first_invoice_merchant = first_invoice.merchant
    assert_kind_of Merchant, first_invoice_merchant
    assert_equal"Schroeder-Jerde", first_invoice_merchant.name  
  end

end
