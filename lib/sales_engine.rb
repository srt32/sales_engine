require_relative 'customer_repository'
require_relative 'customer'
require_relative 'invoice_repository'
require_relative 'invoice'
require_relative 'merchant_repository'
require_relative 'merchant'
require_relative 'transaction_repository'
require_relative 'transaction'
require_relative 'invoice_item_repository'
require_relative 'invoice_item'
require_relative 'item_repository'


class SalesEngine

  attr_reader :data

  def initialize(data = './data')
   @data = data 
  end

  def startup
    
  end

  def customer_repository(filepath= "#{data}/customers_test.csv")
    CustomerRepository.new(filepath)
  end

  def invoice_item_repository(filepath= "#{data}/invoice_item_test.csv")
    InvoiceItemRepository.new(filepath)
  end

  def invoice_repository(filepath= "#{data}/invoice_test.csv")
    InvoiceRepository.new(filepath)
  end

  def item_repository(filepath = "#{data}/items_test.csv")
    ItemRepository.new(filepath)
  end

  def merchant_repository(filepath = "#{data}/merchants_test.csv")
    MerchantRepository.new(filepath)
  end

  def transaction_repository(filepath = "#{data}/transactions_test.csv")
    TransactionRepository.new(filepath)
  end

end
