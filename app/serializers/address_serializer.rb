class AddressSerializer < ActiveModel::Serializer
  attributes :id, :address_type, :employer, :street1, :street2,
    :city, :state_province, :country, :postal_code
  attribute :phone_number, if: :show_phone_number?

  def show_phone_number?
    (show_phone_number = instance_options[:show_phone_number]).present? && show_phone_number
  end

  # def phones
  #   PhoneSerializer.build_array(object.phones)
  # end

end
