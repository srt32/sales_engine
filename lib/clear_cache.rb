module ClearCache

  def clear_cache
    self.class.attributes_string.each do |attribute|
      name = "grouped_by_#{attribute}"
      instance_variable_set("@#{name}",nil)
    end
  end

end
