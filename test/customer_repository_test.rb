require 'minitest/autorun'
require 'minitest/pride'
require './lib/customer_repository'
require 'csv'

class CustomerRepositoryTest < Minitest::Test

  def setup
    @cr = CustomerRepository.new("./test/fixtures/customers.csv",SalesEngine.new("./test/fixtures"))
  end

  def test_it_is_initialized_with_a_filepath
    assert_equal "./test/fixtures/customers.csv", @cr.file_path
  end

  def test_it_populates_all_array_from_csv
     assert_equal 5, @cr.all.count
  end

  def test_it_populates_all_the_customer_data
    customers = @cr.all
    first_customer = customers[0]
    assert_equal 1, first_customer.id
    assert_equal "Joey", first_customer.first_name
    assert_equal "Ondricka", first_customer.last_name
    assert_equal "2012-03-27 14:54:09 UTC", first_customer.created_at
    assert_equal "2012-03-27 14:54:09 UTC", first_customer.updated_at
  end

  def test_it_can_select_a_random_customer_from_all
    random_customers = []
    5.times do
      random_customers << @cr.random
    end
    refute_equal @cr.all, random_customers
  end

  def test_it_return_correct_customer_by_id
    customer = @cr.find_by_id("1")
    assert_equal 1, customer.id
  end

  def test_it_return_correct_customer_by_first_name
    customer = @cr.find_by_first_name("Joey")
    assert_equal "Joey", customer.first_name
  end

  def test_it_return_correct_customer_by_last_name
    customer = @cr.find_by_last_name("Ondricka")
    assert_equal "Ondricka", customer.last_name
  end

  def test_it_return_correct_customer_by_created_at
    customer = @cr.find_by_created_at("2012-03-27 14:54:09 UTC")
    assert_equal "2012-03-27 14:54:09 UTC", customer.created_at
  end

  def test_it_return_correct_customer_by_updated_at
    customer = @cr.find_by_updated_at("2012-03-27 14:54:09 UTC")
    assert_equal "2012-03-27 14:54:09 UTC", customer.updated_at
  end

  def test_it_return_correct_number_of_customers_for_all_id
    customers = @cr.find_all_by_id("1")
    assert_equal 1, customers.count
  end

  def test_it_return_correct_number_of_customers_for_all_first_name
    customers = @cr.find_all_by_first_name("Sylvester")
    assert_equal 2, customers.count
  end

  def test_it_return_correct_number_of_customers_for_all_last_name
    customers = @cr.find_all_by_last_name("Toy")
    assert_equal 2, customers.count
  end

  def test_it_return_correct_number_of_customers_for_all_created_at
    customers = @cr.find_all_by_created_at("2012-03-27 14:54:10 UTC")
    assert_equal 4, customers.count
  end

  def test_it_return_correct_number_of_customers_for_all_updated_at
    customers = @cr.find_all_by_updated_at("2012-03-27 14:54:10 UTC")
    assert_equal 4, customers.count
  end

  def test_it_return_empty_array_for_all_last_name_when_none
    customers = @cr.find_all_by_last_name("Busse")
    assert_equal [], customers
    refute customers.nil?
  end

  def test_it_invoice_collections_given_a_customer
    customer = @cr.find_by_id(1)
    customer_invoices = customer.invoices
    assert_equal 8, customer_invoices.count
  end
end
