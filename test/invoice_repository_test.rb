require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/invoice_repository'

class InvoiceRepositoryTest < MiniTest::Test 

  def setup
    @instance = InvoiceRepository.new("./test/fixtures/invoices.csv",SalesEngine.new("./test/fixtures"))
    @dummy_date = Date.parse "Fri, 25 Mar 2012"
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
    assert_equal @dummy_date, first_invoice.created_at
    assert_equal @dummy_date, first_invoice.updated_at
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
    assert_equal @dummy_date, @instance.find_by_created_at(@dummy_date).created_at
    assert_equal @dummy_date, @instance.find_by_updated_at(@dummy_date).updated_at
  end

  def test_it_returns_correct_value_for_find_by_id_given_integer_input
    assert_equal 1, @instance.find_by_id(1).id
  end

  def test_it_returns_correct_value_for_all_find_method
    assert_equal 1, @instance.find_all_by_id("1").count
    assert_equal 8, @instance.find_all_by_customer_id("1").count
    assert_equal 1, @instance.find_all_by_merchant_id("26").count
    assert_equal 10, @instance.find_all_by_status("shipped").count
    assert_equal 1, @instance.find_all_by_created_at(@dummy_date).count
    assert_equal 1, @instance.find_all_by_updated_at(@dummy_date).count
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
    assert_equal 6, first_invoice_invoice_items.count
    assert_equal BigDecimal.new("136.35"), first_invoice_invoice_items[0].unit_price
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

  #invoice = invoice_repository.create(customer: customer, merchant: merchant, status: "shipped",
                                      #items: [item1, item2, item3])
  def test_it_can_create_a_new_invoice_when_sent_create_with_params
    previous_invoice_count = @instance.all.count
    customer1 = @instance.engine.customer_repository.find_by_id(1)
    merchant1 = @instance.engine.merchant_repository.find_by_id(1)
    item1 = @instance.engine.item_repository.find_by_id(1)
    item2 = @instance.engine.item_repository.find_by_id(2)
    @instance.create(customer: customer1,
                     merchant: merchant1,
                     status: "shipped",
                     items: [item1, item1, item2])
    assert_equal previous_invoice_count + 1, @instance.all.count
  end
   
  def test_it_creates_new_invoice_with_proper_params
    customer1 = @instance.engine.customer_repository.find_by_id(1)
    merchant1 = @instance.engine.merchant_repository.find_by_id(1)
    item1 = @instance.engine.item_repository.find_by_id(1)
    item2 = @instance.engine.item_repository.find_by_id(2)
    @instance.create(customer: customer1,
                     merchant: merchant1,
                     status: "shipped",
                     items: [item1, item1, item2])
    new_invoice = @instance.all.last
    assert_equal 12, new_invoice.id
    assert_equal 1, new_invoice.customer_id
    assert_equal 1, new_invoice.merchant_id
    assert_equal "shipped", new_invoice.status
  end
 
  def test_it_creates_two_related_invoice_items
    customer1 = @instance.engine.customer_repository.find_by_id(1)
    merchant1 = @instance.engine.merchant_repository.find_by_id(1)
    item1 = @instance.engine.item_repository.find_by_id(1)
    item2 = @instance.engine.item_repository.find_by_id(2)
    @instance.create(customer: customer1,
                     merchant: merchant1,
                     status: "shipped",
                     items: [item1, item1, item2])
    previous_invoice_item_count = 11
    new_invoice_item_count = @instance.engine.invoice_item_repository.all.count
    assert_equal previous_invoice_item_count + 2, new_invoice_item_count 
    assert_equal 12, @instance.engine.invoice_item_repository.all[-1].invoice_id
    assert_equal item1.id, @instance.engine.invoice_item_repository.all[-2].item_id
    assert_equal 2, @instance.engine.invoice_item_repository.all[-2].quantity
    assert_equal 1, @instance.engine.invoice_item_repository.all[-1].quantity
  end

end
