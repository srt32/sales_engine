require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative '../lib/transaction_repository'

class TransactionRepositoryTest < Minitest::Test 

  def setup
    @instance = TransactionRepository.new("./test/fixtures/transaction_test.csv")
  end

  def test_that_filepath_is_initialized
    assert_equal "./test/fixtures/transaction_test.csv", @instance.file_path
  end

  def test_open_file_with_default_file_path
    # loaded_data = @instance.open_file
    assert_kind_of CSV, @instance.open_file
  end

  def test_all_method_exists
    assert_respond_to @instance, :all
  end

  def test_that_repo_is_populated_with_data
    # transaction_repo= @instance.all
    assert_equal 10, @instance.all.count
  end

  def test_that_all_attributes_make_it_through_the_parsing
  
  transactions = @instance.all
  first_transaction = transactions[0]
  assert_equal "1", first_transaction.id
  assert_equal "1", first_transaction.invoice_id
  assert_equal "4654405418249632", first_transaction.credit_card_number
  assert_equal "2012-03-27 14:54:09 UTC", first_transaction.created_at
  assert_equal "2012-03-27 14:54:09 UTC", first_transaction.updated_at
  assert_nil(first_transaction.credit_card_expiration_date)
  binding.pry
  assert_equal "success", first_transaction.result
  end

  def 
end
