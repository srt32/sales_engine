require 'csv'

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
    #-go get all the invoice_item.revenue counts and roll up by item_id
    items_rev = engine.invoice_item_repository.all.each_with_object({}) do |ii, ii_revenue| 
      #puts "ii.rev is #{ii.revenue}"
      if ii_revenue[ii.item_id].nil?
        ii_revenue[ii.item_id] = ii.revenue
      else
        ii_revenue[ii.item_id] += ii.revenue
      end
      #puts "ii.rev.total is #{ii_revenue[ii.id]}"
      #puts "ii.id is #{ii.id}"
    end
    #return items_rev

    #-then sort by total sum by item_id
    sorted_items = items_rev.sort_by{|_key,value| value}.reverse[amount]
    #return sorted_items
    
    #-pull out merchant_id from the top of that list
    merchants = sorted_items.collect {|merchant| engine.merchant_repository.find_by_id(merchant[0])}
    return merchants
  end

end
