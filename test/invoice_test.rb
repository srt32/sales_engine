require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/invoice'

class InvoiceTest < Minitest::Test 

  def setup
    @invoice = Invoice.new(:id => "1",
                           :customer_id => "1",
                           :merchant_id => "44",
                           :status => "shipped",
                           :created_at => "2012-03-27 14:54:09 UTC",
                           :updated_at => "2012-03-27 14:54:10 UTC",
                           :invoice_repo_ref => InvoiceRepository.new("./test/fixtures/invoices.csv",SalesEngine.new("./test/fixtures")))
    @failed_invoice = @invoice.invoice_repo_ref.find_by_id(11)
  end
  
  def test_it_can_be_give_a_first_name_last_name_id_created_at_and_updated_at
    assert_equal 1, @invoice.id
    assert_equal 1, @invoice.customer_id
    assert_equal 44, @invoice.merchant_id
    assert_equal "shipped", @invoice.status
    assert_equal created_at_date, @invoice.created_at
    assert_equal updated_at_date, @invoice.updated_at
    assert_kind_of InvoiceRepository, @invoice.invoice_repo_ref
  end

  def created_at_date
    DateTime.strptime("2012-03-27 14:54:09 UTC","%Y-%m-%d %H:%M:%S").to_date
  end

  def updated_at_date
    DateTime.strptime("2012-03-27 14:54:10 UTC","%Y-%m-%d %H:%M:%S").to_date 
  end

  def test_it_can_return_true_if_it_has_a_successful_transaction
    status = @invoice.successful_charge?
    assert status
  end

  def test_it_can_return_false_if_it_does_not_have_a_succssful_transaction
    status = @failed_invoice.successful_charge?
    refute status
  end

  def test_it_rolls_up_revenue_across_invoice_items_properly
    invoice_total_revenue = @invoice.invoice_revenue
    assert_equal BigDecimal.new("13781.43"), invoice_total_revenue
  end

  def test_it_can_create_a_new_transaction_when_told_charge
    previous_transaction_count = @invoice.transactions.count
    @invoice.charge({invoice_id: @invoice.id,
                    credit_card_number: "1234567890",
                    credit_card_expiration: "10/13",
                    result: "success"})
  assert_equal previous_transaction_count + 1, @invoice.transactions.count 
  end
  
end

