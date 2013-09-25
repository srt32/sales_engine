require 'csv'

class InvoiceRepository

  attr_reader :file_path

  def initialize(file_path = "")
    @file_path = file_path
  end

  def csv_data
    CSV.open file_path, headers: true
  end

  def all
    @all ||= create_invoices
  end

  def create_invoices
    csv_data.collect{|row| Invoice.new(row)}
  end
end

# @id = input[:id]
#     @customer_id = input[:customer_id]
#     @merchant_id = input[:merchant_id]
#     @status = input[:status]
#     @created_at = input[:created_at]
#     @updated_at = input[:updated_at]
