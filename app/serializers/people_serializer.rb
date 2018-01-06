class PeopleSerializer < ActiveModel::Serializer
  attributes :id, :firstname, :lastname, :email, :citizenship, :time_zone, :is_expired,
    :home_address, :work_address, :organizations

  def is_expired
    object.expired?
  end

  def home_address
    AddressSerializer.new(object.home_address) if object.home_address
  end

  def work_address
    AddressSerializer.new(object.work_address) if object.work_address
  end

  def organizations
    OrganizationListSerializer.build_array(object.organizations)
  end

end
