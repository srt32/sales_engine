require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'

class SalesEngineTest < MiniTest::Test

  def setup
    @se = SalesEngine.new
  end

  def test_it_responds_to_customer_repository
    assert_respond_to @se, :customer_repository
  end

  def test_it_responds_to_invoice_item_repo
    assert_respond_to @se, :invoice_item_repository
  end

  def test_it_responds_to_invoice_respository
    assert_respond_to @se, :invoice_repository
  end

  def test_it_responds_to_item_repo
    assert_respond_to @se, :item_repository
  end

  def test_it_responds_to_merchant_repository
    assert_respond_to @se, :merchant_repository
  end

  def test_it_responds_to_transaction_repository
    assert_respond_to @se, :transaction_repository
  end

  def test_it_returns_collection_of_customers_with_customer_repo_all_command
    customers = @se.customer_repository("./test/fixtures/customers.csv").all
    assert_equal 5, customers.count
  end

end
