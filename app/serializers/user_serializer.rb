class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :password, :access_token, :expires_time, :magic_link,
    :firstname, :lastname, :screen_name, :employer, :time_zone, :personal_summary,
    :citizenships, :organizations, :addresses

  def addresses
    AddressSerializer.build_array(object.addresses)
  end

  def citizenships
    CitizenshipSerializer.build_array(object.citizenships)
  end

  def organizations
    OrganizationSerializer.build_array(object.organizations)
  end

  def expires_time
    object.expires_at.to_i
  end

  def magic_link
    object.auth.try(:secure_random)
  end

end
