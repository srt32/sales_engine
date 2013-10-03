module FindMethods

  def create_finder_methods(attributes_string)
    attributes_string.each do |attribute|
      define_method("grouped_by_#{attribute}") do 
        if instance_variable_defined? "@grouped_by_#{attribute}"
          instance_variable_get("@grouped_by_#{attribute}")
        else
          instance_variable_set("@grouped_by_#{attribute}",all.group_by{|object| object.send(attribute)})
        end
      end
    end

    attributes_string.each do |attribute|
      define_method("find_by_#{attribute}") do |criteria|
        #all.find{|c| c.send(attribute).to_s == criteria.to_s}
        self.class.send("grouped_by_#{attribute}")[criteria.to_s] || []
      end
    end
    
    attributes_string.each do |attribute|
      define_method("find_all_by_#{attribute}") do |criteria|
        all.find_all{|c| c.send(attribute).to_s == criteria.to_s}
      end
    end

  end

end
