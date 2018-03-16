class UserInventionSerializer < ActiveModel::Serializer
  attributes :id, :user, :access, :role

  def user
    UserSimpleSerializer.new(object.user)
  end

  def role
    RoleSerializer.new(object.role) if object.role
  end

end
