require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/merchant_repository'

class MerchantRepositoryTest < MiniTest::Test

  def setup
    @mr = MerchantRepository.new("./test/fixtures/merchants.csv",SalesEngine.new("./test/fixtures"))
  end

  def test_it_is_initialized_with_a_filepath
    assert_equal "./test/fixtures/merchants.csv", @mr.file_path
  end

  def test_it_populates_all_array_from_csv
    assert_equal 6, @mr.all.count
  end

  def test_it_populates_all_the_customer_data 
    customers = @mr.all
    first_customer = customers[0]
    assert_equal 1, first_customer.id
    assert_equal "Schroeder-Jerde", first_customer.name
    assert_equal "2012-03-27 14:53:59 UTC", first_customer.created_at
    assert_equal "2012-03-27 14:53:59 UTC", first_customer.updated_at
    assert_kind_of MerchantRepository, first_customer.merchant_repo_ref
  end

  def test_it_can_select_a_random_customer_from_all
    random_merchants = []
    5.times do
      random_merchants << @mr.random
    end
    refute_equal [nil,nil,nil,nil,nil], random_merchants
    refute_equal @mr.all, random_merchants
  end

  def test_it_returns_correct_single_merchant_by_attributes
    assert_equal 1,  @mr.find_by_id("1").id
    assert_equal "Schroeder-Jerde", @mr.find_by_name("Schroeder-Jerde").name
    assert_equal "2012-03-27 14:53:59 UTC", @mr.find_by_created_at("2012-03-27 14:53:59 UTC").created_at
    assert_equal "2012-03-27 14:53:59 UTC", @mr.find_by_updated_at("2012-03-27 14:53:59 UTC").updated_at
  end

  def test_it_returns_correct_count_of_merchants_by_all_attributes 
    assert_equal 1, @mr.find_all_by_id("1").count
    assert_equal 2, @mr.find_all_by_name("Williamson Group").count
    assert_equal 6, @mr.find_all_by_created_at("2012-03-27 14:53:59 UTC").count
    assert_equal 5, @mr.find_all_by_updated_at("2012-03-27 14:53:59 UTC").count
  end

  def test_it_returns_empty_array_for_all_name_when_no_results
    merchants = @mr.find_all_by_name("Yankees")
    assert_equal [], merchants
  end

  def test_it_returns_items_collection_given_a_merchant
    first_merchant = @mr.find_by_id("1")                       
    first_merchant_items = first_merchant.items
    assert_equal 3, first_merchant_items.count
    assert_equal "Item Qui Esse", first_merchant_items[0].name
  end

  def test_it_returns_invoices_collection_given_a_merchant
    first_merchant = @mr.find_by_id("1")
    first_merchant_invoices = first_merchant.invoices
    assert_equal 4, first_merchant_invoices.count
  end

  def test_it_returns_top_merchant_when_sent_most_revenue
    #mr = MerchantRepository.new("./data/merchants.csv",SalesEngine.new("./data"))  
    top_revenue_merchants = @mr.most_revenue(2)
    assert_kind_of Merchant, top_revenue_merchants.first
    assert_kind_of Array, top_revenue_merchants
    assert_equal 2, top_revenue_merchants[0].id
    assert_equal "Schroeder-Jerde", top_revenue_merchants.last.name
  end

  def test_it_returns_merchant_collection_based_on_most_items_sold
    most_sold = @mr.most_items(2)
    assert_kind_of Array, most_sold
    assert_kind_of Merchant, most_sold.first
    assert_equal 2, most_sold.length
    assert_equal 1, most_sold.first.id
    assert_equal "Schroeder-Jerde", most_sold.first.name
    assert_equal "Klein, Rempel and Jones", most_sold.last.name
  end

  def test_it_returns_all_revenue_when_given_no_date
    date = Date.parse "Fri, 27 Mar 2012"
    all_revenue = @mr.revenue
    assert_equal 2137424, all_revenue
  end

  def test_it_returns_subset_of_all_revenue_when_given_a_date
    skip
    date = Date.parse "Fri, 28 Mar 2012"
    mar28_revenue = @mr.revenue(date)
    assert_equal 553980, mar28_revenue
  end

end
