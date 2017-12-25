class Organization < ApplicationRecord
  has_many :user_organizations
  has_many :users, through: :user_organizations
  has_many :inventions

  def organization_administrators
    self.user_organizations.where(role: Role.find_by(code: 'organization_administrator')).map(&:user)
  end

end
