class UserRoleSerializer < ActiveModel::Serializer
  attributes :id, :user, :role

  def user
    UserSimpleSerializer.new(object.user)
  end

  def role
    RoleSerializer.new(object.role)
  end

end
