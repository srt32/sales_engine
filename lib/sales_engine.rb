require_relative 'customer_repository'
require_relative 'customer'
#require_relative 'invoice_repository'
require_relative 'invoice'
require_relative 'merchant_repository'
require_relative 'merchant'
#require_relative 'transaction_repository'
require_relative 'transaction'

class SalesEngine

  def initialize(data = './data')
 
  end

  def startup
    
  end

  def customer_repository(filepath= "./data/customers.csv")
    CustomerRepository.new(filepath)
  end

end
