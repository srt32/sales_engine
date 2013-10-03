require 'csv'

class InvoiceRepository

  attr_reader :file_path,
              :engine

  def initialize(file_path = "", engine)
    @file_path = file_path
    @engine = engine
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
                                        :updated_at => row["updated_at"],
                                        :invoice_repo_ref => self)}
  end

  def random
    all.sample
  end

  def create(input)
    new_invoice = Invoice.new(new_invoice_hash(input))
    all << new_invoice
    new_invoice.create_related_invoice_items(input[:items])
    return new_invoice
  end

  def new_invoice_hash(input)
    {:id => all.max_by{|invoice| invoice.id}.id + 1,
                               :customer_id => input[:customer].id,
                               :merchant_id => input[:merchant].id,
                               :status => input[:status],
                               :created_at => Time.now.to_date,
                               :updated_at => Time.now.to_date,
                               :invoice_repo_ref => self}
  end

  %w(id customer_id merchant_id status created_at updated_at).each do |attribute|
    define_method("find_by_#{attribute}") do |criteria|
      all.find{|c| c.send(attribute).to_s == criteria.to_s}
    end
  end

  %w(id customer_id merchant_id status created_at updated_at).each do |attribute|
    define_method("find_all_by_#{attribute}") do |criteria|
      all.find_all{|c| c.send(attribute).to_s == criteria.to_s}
    end
  end

end
