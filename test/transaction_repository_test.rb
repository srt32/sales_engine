require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'csv'

require_relative '../lib/transaction_repository'

class TransactionRepositoryTest < Minitest::Test 

  def setup
    @instance = TransactionRepository.new("./test/fixtures/transactions.csv",SalesEngine.new("./test/fixtures"))
  end

  def test_that_filepath_is_initialized
    assert_equal "./test/fixtures/transactions.csv", @instance.file_path
  end

  def test_that_repo_is_populated_with_data
    assert_equal 10, @instance.all.count
  end

  def test_that_all_attributes_make_it_through_the_parsing
    first_transaction = @instance.all[0]
    assert_equal "1", first_transaction.id
    assert_equal "1", first_transaction.invoice_id
    assert_equal "4654405418249632", first_transaction.credit_card_number
    assert_equal "2012-03-27 14:54:09 UTC", first_transaction.created_at
    assert_equal "2012-03-27 14:54:09 UTC", first_transaction.updated_at
    assert_equal "success", first_transaction.result
  end 

  def test_it_returns_correct_single_transaction_by_attributes
    assert_equal "1", @instance.find_by_id("1").id
    assert_equal "1", @instance.find_by_invoice_id("1").invoice_id
    assert_equal "4654405418249632", @instance.find_by_credit_card_number("4654405418249632").credit_card_number
    assert_equal "2012-03-27 14:54:09 UTC", @instance.find_by_created_at("2012-03-27 14:54:09 UTC").created_at
    assert_equal "2012-03-27 14:54:09 UTC", @instance.find_by_updated_at("2012-03-27 14:54:09 UTC").updated_at
    assert_equal "success", @instance.find_by_result("success").result
  end

  def test_it_returns_find_all
    assert_equal 1, @instance.find_all_by_id("1").count
    assert_equal 2, @instance.find_all_by_invoice_id("1").count
    assert_equal 2, @instance.find_all_by_credit_card_number("4654405418249632").count
    assert_equal 8, @instance.find_all_by_created_at("2012-03-27 14:54:10 UTC").count
    assert_equal 8, @instance.find_all_by_updated_at("2012-03-27 14:54:10 UTC").count
    assert_equal 10, @instance.find_all_by_result("success").count
  end

  def test_it_returns_empty_array_for_all_name_when_no_results
    transactions = @instance.find_all_by_credit_card_number("43890214312890")
    assert_equal [], transactions
  end

  def test_it_can_select_a_random_transaction_from_all
    random_transactions = []
    10.times do
      random_transactions << @instance.random
    end
    refute_equal [nil,nil,nil,nil,nil], random_transactions
    refute_equal @instance.all, random_transactions
  end

  def test_it_returns_invoice_given_a_transaction
    transaction = @instance.find_by_id(1)
    transaction_invoice = transaction.invoice
    assert_equal "26", transaction_invoice.merchant_id
  end

end
