class OrganizationSimpleSerializer < ActiveModel::Serializer
  attributes :id, :name, :business_address, :created_time, :updated_time,
    :highest_role, :user_organization_status

  def highest_role
    user = instance_options[:user]
    return nil if user.nil?
    role = user.highest_role(object)
    return nil if role.nil?
    RoleSerializer.new(role)
  end

  def user_organization_status
    user = instance_options[:user]
    return nil if user.nil?
    s = user.user_organization_statuses.find {|uos| uos.organization_id == object.id}
    return nil if s.nil?
    s.status
  end

  def self.eager_load_array(array)
    array.includes(
      :addresses
    )
  end

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
