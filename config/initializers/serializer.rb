class ActiveModel::Serializer

  def self.build_array(array, serializer_options = {})
    CollectionSerializer.new(array, {serializer: self}.merge(serializer_options))
  end

end
