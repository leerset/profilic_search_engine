class UserOrganizationStatusSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :organization_id, :status, :title, :phone,
    :organization_name, :oa

  def organization_name
    object.organization.name
  end

  def oa
    object.user.oa?(object.organization)
  end
end
