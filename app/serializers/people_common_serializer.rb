class PeopleCommonSerializer < ActiveModel::Serializer
  attributes :id, :email, :password, :access_token, :expires_time, :magic_link, :is_expired, :status,
    :fullname, :firstname, :lastname, :citizenship, :screen_name, :employer, :time_zone, :personal_summary,
    :home_address, :work_address,
    :resume, :resume_filepath

  def fullname
    [object.firstname, object.lastname].compact.join(' ')
  end

  def is_expired
    object.expired?
  end

  def home_address
    AddressSerializer.new(object.home_address) if object.home_address
  end

  def work_address
    AddressSerializer.new(object.work_address) if object.work_address
  end

  def expires_time
    object.expires_at.to_i
  end

end
