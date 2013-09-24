require_relative './transaction'

class TransactionRepository
  attr_reader :file_path, :id

  def initialize(file_path = "")
    @file_path = file_path
  end

  def all 
    @all ||= create_transactions
  end

  def create_transactions
    csv_data = open_file
    all = csv_data.collect {|transaction| Transaction.new(:id => transaction["id"], 
      :invoice_id => transaction["invoice_id"], 
      :credit_card_number => transaction["credit_card_number"], 
      :credit_card_expiration_date => transaction["credit_card_expiration_date"], 
      :result => transaction["result"], 
      :created_at => transaction["created_at"],
      :updated_at => transaction["updated_at"])}
  end

  %w(id invoice_id credit_card_number credit_card_expiration_date result created_at updated_at).each do |attribute| 
    define_method("find_by_#{attribute}") do |criteria|
    all.find{|t| t.send(attribute) == criteria}
    end
  end

  %w(id invoice_id credit_card_number credit_card_expiration_date result created_at updated_at).each do |attribute| 
    define_method("find_all_by_#{attribute}") do |criteria|
    all.find_all{|t| t.send(attribute) == criteria}
    end
  end

  def open_file
    CSV.open file_path, headers: true
  end

  def random
    all.sample
  end
end
