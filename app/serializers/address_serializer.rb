class AddressSerializer < ActiveModel::Serializer
  attributes :id, :address_type, :street_address, :city, :state_province, :postal_code, :phones

  def phones
    PhoneSerializer.build_array(object.phones)
  end

end
