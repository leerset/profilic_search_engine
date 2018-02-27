class SearchSerializer < ActiveModel::Serializer
  attributes :id, :title, :url, :note, :tag

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end
end
