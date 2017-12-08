class Organization < ApplicationRecord
  has_many :user_organizations
  has_many :users, through: :user_organizations

  def creator
    self.user_organizations.where(role: Role.find_by(name: 'creator')).first.try(:user)
  end

end
