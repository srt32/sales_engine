require_relative './transaction'

class TransactionRepository

  attr_reader :file_path

  def initialize(file_path = "")
    @file_path = file_path
  end

  def all 
    @all ||= create_transactions
  end

  def create_transactions
    csv_data.collect {|row| Transaction.new(:id => row["id"],
                                            :invoice_id => row["invoice_id"],
                                            :credit_card_number => row["credit_card_number"],
                                            :result => row["result"],
                                            :name => row["name"],
                                            :created_at => row["created_at"],
                                            :updated_at => row["updated_at"])}
  end

  %w(id invoice_id credit_card_number result created_at updated_at).each do |attribute| 
    define_method("find_by_#{attribute}") do |criteria|
      all.find{|t| t.send(attribute) == criteria.to_s}
    end
  end

  %w(id invoice_id credit_card_number result created_at updated_at).each do |attribute| 
    define_method("find_all_by_#{attribute}") do |criteria|
    all.find_all{|t| t.send(attribute) == criteria.to_s}
    end
  end

  def csv_data
    CSV.open file_path, headers: true
  end

  def random
    all.sample
  end
end
