require 'csv'
require_relative './item'

class ItemRepository

  attr_reader :file_path

  def initialize(file_path = "")
    @file_path = file_path
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
                                     :updated_at => row["updated_at"]
    )}
  end

  def open_file
    CSV.open file_path, headers: true
  end

  def random
    all.sample
  end

  %w(id name description unit_price merchant_id created_at updated_at).each do |attribute|
    define_method("find_by_#{attribute}") do |criteria| 
      all.find{|c| c.send(attribute) == criteria}
    end
  end
 
  %w(id name description unit_price merchant_id created_at updated_at).each do |attribute|
    define_method("find_all_by_#{attribute}") do |criteria| 
      all.find_all{|c| c.send(attribute) == criteria}
    end
  end

end
