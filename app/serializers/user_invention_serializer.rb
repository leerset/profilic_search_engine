class UserInventionSerializer < ActiveModel::Serializer
  attributes :id, :user, :invention, :role

  def user
    UserSerializer.new(object.user)
  end

  def invention
    InventionSerializer.new(object.invention)
  end

  def role
    RoleSerializer.new(object.role) if object.role
  end

end
