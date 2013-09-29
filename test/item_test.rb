require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/item.rb'

class ItemTest < Minitest::Test

  def test_it_can_be_given_all_its_attributes
    item = Item.new(:id => "1",
                    :name =>"Spam",
                    :description =>"The best meat on earth",
                    :unit_price =>"1000",
                    :merchant_id =>"1",
                    :created_at =>"2012-03-27 14:53:59 UTC",
                    :updated_at =>"2012-03-27 14:53:59 UTC")
    assert_equal "1", item.id
    assert_equal "Spam", item.name
    assert_equal "The best meat on earth", item.description
    assert_equal "1000", item.unit_price
    assert_equal "1", item.merchant_id
    assert_equal "2012-03-27 14:53:59 UTC", item.created_at
    assert_equal "2012-03-27 14:53:59 UTC", item.updated_at
  end

end
