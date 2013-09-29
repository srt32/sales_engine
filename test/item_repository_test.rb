require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/item_repository'

class ItemRepositoryTest < Minitest::Test

  def setup
    @ir = ItemRepository.new("./test/fixtures/items.csv",SalesEngine.new("./test/fixtures"))
  end

  def test_it_is_initialized_with_a_filepath
    assert_equal "./test/fixtures/items.csv", @ir.file_path
  end

  def test_it_populates_all_array_from_csv
    assert_equal 4, @ir.all.count
  end

  def test_it_populates_all_the_merchant_data
    items = @ir.all
    first_item = items[0]
    assert_equal "1", first_item.id
    assert_equal "Item Qui Esse", first_item.name
    assert_equal "Nihil autem sit odio inventore deleniti. Est laudantium ratione distinctio laborum. Minus voluptatem nesciunt assumenda dicta voluptatum porro.", first_item.description
    assert_equal "75107", first_item.unit_price
    assert_equal "1", first_item.merchant_id
    assert_equal "2012-03-27 14:53:59 UTC", first_item.created_at
    assert_equal "2012-03-27 14:53:59 UTC", first_item.updated_at
  end

  def test_it_can_select_a_random_customer_from_all
    random_items = []
    5.times do
      random_items << @ir.random
    end
    refute_equal [nil,nil,nil,nil,nil], random_items
    refute_equal @ir.all, random_items
  end

   def test_it_returns_correct_single_item_by_attributes
    assert_equal "1", @ir.find_by_id("1").id
    assert_equal "Item Qui Esse", @ir.find_by_name("Item Qui Esse").name
    assert_equal "Nihil autem sit odio inventore deleniti. Est laudantium ratione distinctio laborum. Minus voluptatem nesciunt assumenda dicta voluptatum porro.",  @ir.find_by_description("Nihil autem sit odio inventore deleniti. Est laudantium ratione distinctio laborum. Minus voluptatem nesciunt assumenda dicta voluptatum porro.").description
    assert_equal "75107", @ir.find_by_unit_price("75107").unit_price
    assert_equal "1", @ir.find_by_merchant_id("1").merchant_id
    assert_equal "2012-03-27 14:53:59 UTC", @ir.find_by_created_at("2012-03-27 14:53:59 UTC").created_at
    assert_equal "2012-03-27 14:53:59 UTC", @ir.find_by_updated_at("2012-03-27 14:53:59 UTC").updated_at
   end

  def test_it_returns_correct_count_of_merchants_by_all_attributes
    assert_equal 1, @ir.find_all_by_id("1").count
    assert_equal 1, @ir.find_all_by_name("Item Qui Esse").count
    assert_equal 1,  @ir.find_all_by_description("Nihil autem sit odio inventore deleniti. Est laudantium ratione distinctio laborum. Minus voluptatem nesciunt assumenda dicta voluptatum porro.").count
    assert_equal 1, @ir.find_all_by_unit_price("75107").count
    assert_equal 4, @ir.find_all_by_merchant_id("1").count
    assert_equal 4, @ir.find_all_by_created_at("2012-03-27 14:53:59 UTC").count
    assert_equal 4, @ir.find_all_by_updated_at("2012-03-27 14:53:59 UTC").count
   end

  def test_it_returns_empty_array_for_all_name_when_no_results
    items = @ir.find_all_by_name("Little Red Riding Hood")
    assert_equal [], items
  end

end
