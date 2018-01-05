class OrganizationListSerializer < ActiveModel::Serializer
  attributes :id, :organization_name, :business_address, :created_time, :updated_time

  def organization_name
    object.name
  end

  def business_address
    AddressSerializer.new(object.business_address) if object.business_address
  end

  def administrators_statuses
    UserOrganizationStatusSerializer.build_array(object.administrators_statuses)
  end

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end

end
