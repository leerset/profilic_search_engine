class UserRoleSerializer < ActiveModel::Serializer
  attributes :id, :user, :role

  def user
    UserSerializer.new(object.user)
  end

  def role
    RoleSerializer.new(object.role)
  end

end
