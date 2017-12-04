class ConceptDertailSerializer < ActiveModel::Serializer
  attributes :id, :owner, :title, :summary, :created_by, :created_time, :updated_time

  def self.build_array(array)
    CollectionSerializer.new(array, serializer: self)
  end

  def owner
    UserSerializer.new(object.user)
  end

  def title
    object.url
  end

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end

end
