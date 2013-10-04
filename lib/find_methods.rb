module FindMethods

  def create_finder_methods(attributes_string)
    attributes_string.each do |attribute|
      define_method("grouped_by_#{attribute}") do 
        name = "@grouped_by_#{attribute}"
        unless instance_variable_get(name).nil?
          instance_variable_get(name)
        else
          instance_variable_set(name, all.group_by{|object| object.send(attribute).to_s})
        end
        return instance_variable_get(name)
      end
    end

    attributes_string.each do |attribute|
      define_method("find_by_#{attribute}") do |criteria|
        Array(send("grouped_by_#{attribute}")[criteria.to_s]).first
      end
    end
    
    attributes_string.each do |attribute|
      define_method("find_all_by_#{attribute}") do |criteria|
        Array(send("grouped_by_#{attribute}")[criteria.to_s])
      end
    end

  end

end
