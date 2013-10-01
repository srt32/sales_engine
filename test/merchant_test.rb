require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/merchant.rb'

class MerchantTest < MiniTest::Test

  def setup
    @merchant = Merchant.new(:id => "1",
                            :name => "Florist Fryers", 
                            :created_at => "2012-03-27 14:54:09 UTC", 
                            :updated_at => "2012-03-27 14:54:10 UTC",
                            :merchant_repo_ref => MerchantRepository.new("./test/fixtures/merchants_test.csv",SalesEngine.new("./test/fixtures")))
  end

  def test_it_can_be_give_all_its_attributes
    assert_equal "Florist Fryers", @merchant.name
    assert_equal 1, @merchant.id
    assert_equal "2012-03-27 14:54:09 UTC", @merchant.created_at
    assert_equal "2012-03-27 14:54:10 UTC", @merchant.updated_at
    assert_kind_of MerchantRepository, @merchant.merchant_repo_ref
  end

  def test_it_returns_total_revenue_across_all_successful_transactions
    revenue = @merchant.revenue
    assert_equal 495488, revenue
  end

  def test_it_returns_favorite_customer
    fav_customer = @merchant.favorite_customer
    assert_kind_of Customer, fav_customer
    assert_equal 1, fav_customer.id
  end

  def test_it_returns_customers_with_outstanding_charges
    customers = @merchant.customers_with_pending_invoices
    assert_kind_of Customer, customers[0]
    assert_equal 3, customers[0].id 
  end

end
