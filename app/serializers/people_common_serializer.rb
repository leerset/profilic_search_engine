class PeopleCommonSerializer < ActiveModel::Serializer
  attributes :id, :firstname, :lastname, :email, :citizenship, :time_zone, :is_expired, :status,
    :home_address, :work_address

  def is_expired
    object.expired?
  end

  def home_address
    AddressSerializer.new(object.home_address) if object.home_address
  end

  def work_address
    AddressSerializer.new(object.work_address) if object.work_address
  end

end
