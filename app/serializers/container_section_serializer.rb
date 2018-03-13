class ContainerSectionSerializer < ActiveModel::Serializer
  attributes :id, :invention_id, :draw, :significance, :created_time, :updated_time

  def draw
    {content: object.draw}
  end

  def significance
    {content: object.significance}
  end

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end
end
