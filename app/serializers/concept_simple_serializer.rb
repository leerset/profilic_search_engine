class ConceptSimpleSerializer < ActiveModel::Serializer
  attributes :id, :owner, :title, :created_by, :created_time, :updated_time

  def owner
    UserSimpleSerializer.new(object.user)
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
