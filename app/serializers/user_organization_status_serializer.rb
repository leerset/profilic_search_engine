class UserOrganizationStatusSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :user_name, :organization_id, :organization_name,
    :status, :title, :phone, :oa

  def user_name
    object.user.full_name
  end

  def organization_name
    object.organization.name
  end

  def oa
    object.user.oa?(object.organization)
  end
end
