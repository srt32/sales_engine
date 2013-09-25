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
    csv_data.collect{|row| Invoice.new( :id => row["id"],
                                        :customer_id => row["customer_id"],
                                        :merchant_id => row["merchant_id"],
                                        :status => row["status"],
                                        :created_at => row["created_at"],
                                        :updated_at => row["updated_at"] )}
  end

  def random
    all.sample
  end

  %w(id customer_id merchant_id status created_at updated_at).each do |attribute|
    define_method("find_by_#{attribute}") do |criteria|
      all.find{|c| c.send(attribute) == criteria}
    end
  end

  %w(id customer_id merchant_id status created_at updated_at).each do |attribute|
    define_method("find_all_by_#{attribute}") do |criteria|
      all.find_all{|c| c.send(attribute) == criteria}
    end
  end
end
