class EagerLoadCollectionSerializer < ActiveModel::Serializer::CollectionSerializer
  def initialize(array, options = {})
    if options[:serializer].respond_to?(:eager_load_array)
      array = options[:serializer].eager_load_array(array)
    end

    super(array, options)
  end
end
