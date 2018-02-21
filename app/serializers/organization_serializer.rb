class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :business_address, :created_time, :updated_time,
    :admins_amount, :inventors_amount, :members_amount,
    :submissions_amount, :inventions_amount, :invention_opportunities_amount,
    :administrators_statuses

  def admins_amount
    object.administrators.count
  end

  def inventors_amount
    object.inventors.count
  end

  def members_amount
    object.members.count
  end

  def submissions_amount
    0
  end

  def inventions_amount
    object.inventions.count
  end

  def invention_opportunities_amount
    object.invention_opportunities.count
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
