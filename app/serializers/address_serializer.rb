class AddressSerializer < ActiveModel::Serializer
  attributes :id, :address_type, :employer, :street1, :street2, :city, :state_province, :country, :postal_code

  # def phones
  #   PhoneSerializer.build_array(object.phones)
  # end

end
