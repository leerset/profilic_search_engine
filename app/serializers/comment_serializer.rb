class CommentSerializer < ActiveModel::Serializer
  attributes :id, :user_name, :content, :created_time, :updated_time

  def user_name
    object.user.full_name
  end

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end
end
