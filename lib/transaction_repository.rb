require_relative './transaction'
require_relative './find_methods'

class TransactionRepository
  extend FindMethods

  attr_reader :file_path,
              :engine

  def initialize(file_path = "",engine)
    @file_path = file_path
    @engine = engine
  end

  def all
    @all ||= create_transactions
  end

  def create_transactions
    csv_data.collect do |row|
      Transaction.new(:id => row["id"],
                      :invoice_id => row["invoice_id"],
                      :credit_card_number => row["credit_card_number"],
                      :result => row["result"],
                      :name => row["name"],
                      :created_at => row["created_at"],
                      :updated_at => row["updated_at"],
                      :transaction_repo_ref => self)
    end
  end

  def self.attributes_string
    %w(id invoice_id credit_card_number result created_at updated_at)
  end

   def csv_data
    CSV.open file_path, headers: true
  end

  def random
    all.sample
  end

  def create(input)
    all << Transaction.new(input)
  end

  create_finder_methods(attributes_string)
end
