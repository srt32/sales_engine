require 'csv'
require_relative './find_methods'

class CustomerRepository
  extend FindMethods

  attr_reader :file_path,
              :engine

  def initialize(file_path = "",engine)
    @file_path = file_path
    @engine = engine
  end

  def all
    @all ||= create_customers
  end

  def random
    all.sample
  end

  def self.attributes_string
    %w(id first_name last_name created_at updated_at)
  end

  def create_customers
    all = open_file.collect{|row| Customer.new(:id => row["id"],
      :first_name => row["first_name"],
      :last_name => row["last_name"],
      :created_at => row["created_at"],
      :updated_at => row["updated_at"],
      :customer_repo_ref => self)}
  end

  def open_file
    CSV.open file_path, headers: true
  end

  self.create_finder_methods(attributes_string)
end
