class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :password, :access_token, :expires_time, :magic_link,
    :firstname, :lastname, :screen_name, :employer, :time_zone, :personal_summary

  def expires_time
    object.expires_at.to_i
  end

  def magic_link
    object.auth.try(:secure_random)
  end

end
