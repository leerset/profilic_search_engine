class ParticipantSerializer < ActiveModel::Serializer
  attributes :id, :user_name, :role_code, :organization_name, :user_organization_role_codes

  def user_name
    object.user.full_name
  end

  def role_code
    object.role.code
  end

  def organization_name
    object.invention.organization.name
  end

  def user_organization_role_codes
    object.user.organization_roles(object.invention.organization).map(&:code)
  end

end
