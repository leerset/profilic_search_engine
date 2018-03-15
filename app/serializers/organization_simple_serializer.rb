class OrganizationSimpleSerializer < ActiveModel::Serializer
  attributes :id, :name, :business_address, :created_time, :updated_time

  def business_address
    AddressSerializer.new(object.business_address) if object.business_address
  end

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end

end
