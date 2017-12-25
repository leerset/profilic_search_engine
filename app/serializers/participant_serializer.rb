class ParticipantSerializer < ActiveModel::Serializer
  attributes :id, :user_name, :role_name, :user_organization_roles

  def user_name
    object.user.full_name
  end

  def role_name
    object.role.name
  end

  def user_organization_roles
    object.user.organization_roles(object.invention.organization)
  end

end
