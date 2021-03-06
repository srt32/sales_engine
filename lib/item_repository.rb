require 'csv'
require_relative './item'
require_relative './find_methods'
require_relative './clear_cache'

class ItemRepository
  extend FindMethods
  include ClearCache

  attr_reader :file_path,
              :engine

  def initialize(file_path = "",engine)
    @file_path = file_path
    @engine = engine
  end

  def all
    @all ||= create_items
  end

  def create_items
    open_file.collect{|row| Item.new(:id => row["id"],
                                     :name => row["name"],
                                     :description => row["description"],
                                     :unit_price => row["unit_price"],
                                     :merchant_id => row["merchant_id"],
                                     :created_at => row["created_at"],
                                     :updated_at => row["updated_at"],
                                     :item_repo_ref => self
    )}
  end

  def open_file
    CSV.open file_path, headers: true
  end

  def random
    all.sample
  end

  def self.attributes_string
    %w(id name description unit_price merchant_id created_at updated_at)
  end

  def most_items(amount)
    invoice_item_repository.total_quantity_sold[0..amount-1].collect do |item| 
      find_by_id(item[0])
    end
  end

  def most_revenue(amount)
    invoice_item_repository.total_revenue_sold[0..amount-1].collect do |item| 
      find_by_id(item[0])
    end
  end

  def invoice_item_repository
    engine.invoice_item_repository
  end

  self.create_finder_methods(attributes_string)

end
