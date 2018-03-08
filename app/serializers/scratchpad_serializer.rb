class ScratchpadSerializer < ActiveModel::Serializer
  attributes :id, :invention_id, :content, :created_time, :updated_time

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end
end