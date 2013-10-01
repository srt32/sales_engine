require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/item.rb'

class ItemTest < Minitest::Test

  attr_reader :item

  def setup
    @item = Item.new(:id => "1",
                    :name =>"Spam",
                    :description =>"The best meat on earth",
                    :unit_price =>"1000",
                    :merchant_id =>"1",
                    :created_at =>"2012-03-27 14:53:59 UTC",
                    :updated_at =>"2012-03-27 14:53:59 UTC",
                    :item_repo_ref => ItemRepository.new("./test/fixtures/items.csv",SalesEngine.new("./test/fixtures")))
    
  end

  def test_it_can_be_given_all_its_attributes
    assert_equal 1, item.id
    assert_equal "Spam", item.name
    assert_equal "The best meat on earth", item.description
    assert_equal BigDecimal.new("10.00"), item.unit_price
    assert_equal 1, item.merchant_id
    assert_equal "2012-03-27 14:53:59 UTC", item.created_at
    assert_equal "2012-03-27 14:53:59 UTC", item.updated_at
    assert_kind_of ItemRepository, item.item_repo_ref
  end

  def test_it_returns_highest_selling_day_given_date
    best_day_ever = item.best_day
    date = Date.parse("Mar 25, 2012")
    assert_equal date, best_day_ever
  end

end
