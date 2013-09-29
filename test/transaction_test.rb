require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/transaction'

class TransactionTest < Minitest::Test

  def setup
   @failed_transaction =  Transaction.new(
      :id => "4", 
      :invoice_id => "5", 
      :credit_card_number => "81930383492010", 
      :result => "failure", 
      :created_at => "2012-03-27 14:54:09 UTC", 
      :updated_at => "2012-03-27 14:54:10 UTC",
      :transaction_repo_ref => TransactionRepository.new("./test/fixtures/transactions.csv",SalesEngine.new))
    
   @successful_transaction =  Transaction.new(
      :id => "5", 
      :invoice_id => "5", 
      :credit_card_number => "81930383492010", 
      :result => "success", 
      :created_at => "2012-03-27 14:54:09 UTC", 
      :updated_at => "2012-03-27 14:54:10 UTC",
      :transaction_repo_ref => TransactionRepository.new("./test/fixtures/transactions.csv",SalesEngine.new))
  end

  def test_it_can_be_given_attributes 
        assert_equal 4, @failed_transaction.id
        assert_equal 5, @failed_transaction.invoice_id
        assert_equal "81930383492010", @failed_transaction.credit_card_number
        assert_equal "failure", @failed_transaction.result
        assert_equal "2012-03-27 14:54:09 UTC", @failed_transaction.created_at
        assert_equal "2012-03-27 14:54:10 UTC", @failed_transaction.updated_at
        assert_kind_of TransactionRepository, @failed_transaction.transaction_repo_ref
  end

  def test_it_returns_false_when_asked_successful_for_failed_transaction
    status = @failed_transaction.successful?
    refute status
  end

  def test_it_returns_true_when_asked_successful_for_successful_transaction
    status = @successful_transaction.successful?
    assert status
  end

end
