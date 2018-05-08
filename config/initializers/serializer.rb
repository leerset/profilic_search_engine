class ActiveModel::Serializer

  def self.build_array(array, serializer_options = {})
    if array.any?
      EagerLoadCollectionSerializer.new(array, {serializer: self}.merge(serializer_options))
    else
      CollectionSerializer.new(array, serializer: self)
    end
  end

end
