class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :password, :access_token, :expires_time, :magic_link,
    :firstname, :lastname, :citizenship, :screen_name, :employer, :time_zone, :personal_summary,
    :languages, :home_address, :work_address,
    # :citizenships,
    :resume, :resume_filepath

  def home_address
    AddressSerializer.new(object.home_address) if object.home_address
  end

  def work_address
    AddressSerializer.new(object.work_address) if object.work_address
  end

  # def citizenships
  #   CitizenshipSerializer.build_array(object.citizenships)
  # end

  def languages
    LanguageSerializer.build_array(object.languages)
  end

  def expires_time
    object.expires_at.to_i
  end

end
