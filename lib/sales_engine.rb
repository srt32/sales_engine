require_relative 'customer_repository'
require_relative 'customer'
#require_relative 'invoice_repository'
require_relative 'invoice'
require_relative 'merchant_repository'
require_relative 'merchant'
#require_relative 'transaction_repository'
require_relative 'transaction'
require_relative 'invoice_item_repository'
require_relative 'invoice_item'

class SalesEngine

  def initialize(data = './data')
 
  end

  def startup
    
  end

  def customer_repository(filepath= "./data/customers.csv")
    CustomerRepository.new(filepath)
  end

  def invoice_item_repository(filepath= "./data/invoice_items.csv")
    InvoiceItemRepository.new(filepath)
  end

  def invoice_repository(filepath= "./data/invoices.csv")
    InvoiceRepository.new(filepath)
  end

  def item_repository(filepath = "")
    ItemRepository.new(filepath)
  end

  def merchant_repository(filepath = "")
    MerchantRepository.new(filepath)
  end

  def transaction_repository(filepath = "")
    TransactionRepository.new(filepath)
  end

end
