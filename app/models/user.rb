class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :concepts
  has_one :auth

  after_create :create_auth

  def create_auth
    self.build_auth(secure_random: Auth.generate_secure_random)
  end

end
