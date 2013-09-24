# require_relative './Transaction'

class TransactionRepository
  attr_reader :file_path

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

  def open_file
    CSV.open file_path, headers: true
  end
end
