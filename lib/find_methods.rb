module FindMethods

  def create_finder_methods(attributes_string)
    attributes_string.each do |attribute|
      define_method("find_by_#{attribute}") do |criteria|
        all.find{|c| c.send(attribute).to_s == criteria.to_s}
      end
    end
    
    attributes_string.each do |attribute|
      define_method("find_all_by_#{attribute}") do |criteria|
        all.find_all{|c| c.send(attribute).to_s == criteria.to_s}
      end
    end
  end

end
