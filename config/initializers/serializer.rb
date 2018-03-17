class ActiveModel::Serializer

  def self.build_array(array, serializer_options = {})
    RelationSerializer.new(array, {serializer: self}.merge(serializer_options))
  end

end

