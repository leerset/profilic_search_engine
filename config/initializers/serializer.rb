class ActiveModel::Serializer

  def self.build_array(array)
    CollectionSerializer.new(array, serializer: self)
  end

end
