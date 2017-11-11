class Auth < ApplicationRecord
  belongs_to :user

  def to_param
    secure_random
  end

  def reset_secure_random
    self.update(secure_random: Auth.generate_secure_random)
  end

  def self.generate_secure_random
    begin
      secure_random = SecureRandom.base58
    end while Auth.where(secure_random: secure_random).present?
    secure_random
  end
end
