class ParticipantSerializer < ActiveModel::Serializer
  attributes :id, :user_name, :role_name

  def user_name
    object.user.full_name
  end

  def role_name
    object.role.name
  end

end
