require 'minitest/autorun'
require 'minitest/pride'
require './lib/customer'

class CustomerTest < MiniTest::Test

  def setup
    @customer = Customer.new(:id => "1",
                            :first_name => "Simon",
                            :last_name => "Bolivar",
                            :created_at => "2012-03-27 14:54:09 UTC",
                            :updated_at => "2012-03-27 14:54:10 UTC",
                            :customer_repo_ref => CustomerRepository.new("./test/fixtures/customers.csv",SalesEngine.new))
     
  end

  def test_it_can_be_give_a_first_name_last_name_id_created_at_and_updated_at
    assert_equal "Simon", @customer.first_name
    assert_equal "Bolivar", @customer.last_name
    assert_equal 1, @customer.id
    assert_equal "2012-03-27 14:54:09 UTC", @customer.created_at
    assert_equal "2012-03-27 14:54:10 UTC", @customer.updated_at
    assert_kind_of CustomerRepository, @customer.customer_repo_ref
  end
  
  def test_it_returns_transactions_array_for_the_customer
    transactions = @customer.transactions
    assert_kind_of Transaction, transactions[0]
    assert_equal 7, transactions.length
    assert_equal 1, transactions[0].id
  end

end
