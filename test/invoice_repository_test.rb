require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/invoice_repository'

class InvoiceRepositoryTest < MiniTest::Test 

  def setup
    @instance = InvoiceRepository.new("./test/fixtures/invoice_test.csv")
  end

  def test_it_is_initialized_with_a_filepath
    assert_equal "./test/fixtures/invoice_test.csv", @instance.file_path
  end

  def test_it_has_information_in_array_from_csv
    assert_equal 9, @instance.all.count
  end

  def test_it_gathers_all_invoice_data
    first_invoice = (@instance.all)[0]
    assert_equal "1", first_invoice.id
    # assert_equal "1", first_invoice.customer_id
    # assert_equal ""
    # assert_equal "", first_invoice.merchant_id
    # assert_equal "", first_invoice.status
    # assert_equal "", first_invoice.created_at
    # assert_equal "", first_invoice.updated_at
  end
end
