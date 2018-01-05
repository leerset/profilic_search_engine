class UserOrganizationSerializer < ActiveModel::Serializer
  attributes :id, :user, :organization, :role

  def user
    UserSerializer.new(object.user)
  end

  def organization
    OrganizationSerializer.new(object.organization)
  end

  def role
    RoleSerializer.new(object.role) if object.role
  end

  def status
    UserOrganizationStatusSerializer.new(object.status) if object.status
  end

end
