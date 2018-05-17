class OrganizationListSerializer < ActiveModel::Serializer
  attributes :id, :name, :business_address, :created_time, :updated_time,
    :admins_amount, :inventors_amount, :submissions_amount, :inventions_amount,
    :highest_role

  def highest_role
    user = instance_options[:user]
    return nil if user.nil?
    role = user.highest_role(object)
    return nil if role.nil?
    RoleSerializer.new(role)
  end

  def admins_amount
    object.administrators.count
  end

  def inventors_amount
    object.inventors.count
  end

  def submissions_amount
    0
  end

  def inventions_amount
    object.inventions.count
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
