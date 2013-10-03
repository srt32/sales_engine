require 'csv'
require_relative './find_methods'

class MerchantRepository
  extend FindMethods

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

  def self.attributes_string
    %w(id name created_at updated_at)
  end

  def most_revenue(amount)
    all.each_with_object(Hash.new(0)) do |merchant, total|
      total[merchant.id] = merchant.revenue
    end.sort_by{|_,sum| sum}.reverse[0..amount-1].collect{|merchant| find_by_id(merchant[0])}
  end

  def most_items(amount)
    top_selling_merchant_ids = all.each_with_object(Hash.new(0)) do |merchant, frequency|
      frequency[merchant.id] = merchant.items_successfully_sold
    end.sort_by{|_,count| count}.reverse[0..amount-1]
    top_selling_merchant_ids.collect{|merchant| find_by_id(merchant[0])}
  end

  def revenue(date = "")
     all.reduce(0){|sum,merchant| sum += merchant.revenue(date)}
  end

  self.create_finder_methods(attributes_string)

end
