class ScratchpadSerializer < ActiveModel::Serializer
  attributes :id, :invention_id, :content, :created_time, :updated_time

  def content
    object.content.to_s
  end

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end
end
