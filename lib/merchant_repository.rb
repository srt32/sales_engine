require 'csv'
require 'pry'

class MerchantRepository

  attr_reader :file_path,
              :engine

  def initialize(file_path = "",engine)
    @file_path = file_path
    @engine = engine
  end

  def all
    @all ||= create_merchants
  end

  def create_merchants
    csv_data = open_file
    all = csv_data.collect{|row| Merchant.new(:id => row["id"],
                                              :name => row["name"],
                                              :created_at => row["created_at"],
                                              :updated_at => row["updated_at"],
                                              :merchant_repo_ref => self)}
  end

  def open_file
    CSV.open file_path, headers: true    
  end

  def random
    all.sample
  end

  %w(id name created_at updated_at).each do |attribute|
    define_method("find_by_#{attribute}") do |criteria| 
      all.find{|c| c.send(attribute).to_s == criteria.to_s}
    end
  end
 
  %w(id name created_at updated_at).each do |attribute|
    define_method("find_all_by_#{attribute}") do |criteria| 
      all.find_all{|c| c.send(attribute).to_s == criteria.to_s}
    end
  end

  def most_revenue(amount)
    sorted_items_rev = engine.invoice_item_repository.total_revenue_sold 
    sorted_items = sorted_items_rev[0..amount-1]
    top_items = sorted_items.collect {|item| engine.item_repository.find_by_id(item[0])}
    merchants = top_items.collect {|item| find_by_id(item.merchant_id)}
   # binding.pry
    merchants = merchants.reject{|m| m.nil?}
    #binding.pry
    return merchants
  end

  def most_items(amount)
    totals_with_ids = engine.invoice_item_repository.total_quantity_sold[0..amount-1]
    sorted_items = totals_with_ids.collect {|item| engine.item_repository.find_by_id(item[0])}
    merchants = sorted_items.collect{|item| find_by_id(item.merchant_id)}
    #binding.pry
    return merchants
  end

end
