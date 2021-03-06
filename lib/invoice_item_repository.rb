require_relative './find_methods'
require_relative './clear_cache'

class InvoiceItemRepository
  extend FindMethods
  include ClearCache

  attr_reader :file_path,
              :engine

  def initialize(file_path = "", engine)
    @file_path = file_path
    @engine = engine
  end

  def open_file
    CSV.open file_path, headers: true
  end

  def all
    @all ||= create_invoice_items
  end

  def create_invoice_items
    open_file.collect{|row| InvoiceItem.new(:id => row["id"],
                                              :item_id => row["item_id"],
                                              :invoice_id => row["invoice_id"],
                                              :quantity => row["quantity"],
                                              :unit_price => row["unit_price"],
                                              :created_at => row["created_at"],
                                              :updated_at => row["updated_at"],
                                              :invoice_item_repo_ref => self)}
  end

  def random
    all.sample
  end

  def self.attributes_string
    %w(id item_id invoice_id quantity unit_price created_at updated_at)
  end

  def total_quantity_sold
    all.each_with_object(Hash.new(0)) do |ii, frequencies|
      frequencies[ii.item_id] += ii.quantity.to_i if ii.successful_charge?
    end.sort_by{|_,frequency| -frequency}
  end

  def total_revenue_sold
    all.each_with_object(Hash.new(0)) do |ii, ii_revenue|
      ii_revenue[ii.item_id] += ii.revenue
    end.sort_by{|_key,value| -value}
  end

  def create(input)
    clear_cache
    all << InvoiceItem.new(input)
  end

  self.create_finder_methods(attributes_string)

end
