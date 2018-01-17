class ActiveModel::Serializer

  def self.build_array(array, serializer_options = {})
    CollectionSerializer.new(array, serializer_options.merge(serializer: self))
  end

end
