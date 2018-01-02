class PeopleSerializer < ActiveModel::Serializer
  attributes :id, :firstname, :lastname, :email, :citizenship, :time_zone,
    :home_address, :work_address, :organizations

  def home_address
    AddressSerializer.new(object.home_address)
  end

  def work_address
    AddressSerializer.new(object.work_address)
  end

  def user_organization_status
    OrganizationSerializer.build_array(object.organizations)
  end

end
