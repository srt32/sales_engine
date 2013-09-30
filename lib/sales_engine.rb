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

  def customer_repository(filepath= "#{data}/customers.csv")
    @customer_repository ||= CustomerRepository.new(filepath,self)
  end

  def invoice_item_repository(filepath= "#{data}/invoice_items.csv")
    @invoice_item_repository ||= InvoiceItemRepository.new(filepath,self)
  end

  def invoice_repository(filepath= "#{data}/invoices.csv")
    @invoice_repository ||= InvoiceRepository.new(filepath,self)
  end

  def item_repository(filepath = "#{data}/items.csv")
    @item_repository ||= ItemRepository.new(filepath,self)
  end

  def merchant_repository(filepath = "#{data}/merchants.csv")
    @merchant_repository ||= MerchantRepository.new(filepath,self)
  end

  def transaction_repository(filepath = "#{data}/transactions.csv")
    @transaction_repository ||= TransactionRepository.new(filepath,self)
  end

end
