class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :password, :access_token, :expect_time

  def expect_time
    object.expect_at.to_i
  end

end
