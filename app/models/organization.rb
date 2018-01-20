class Organization < ApplicationRecord
  has_many :user_organizations
  has_many :users, through: :user_organizations
  has_many :inventions

  has_many :organization_addresses
  has_many :addresses, through: :organization_addresses

  has_many :user_organization_statuses

  def inventors
    self.user_organizations.where(role: Role.find_by(code: (1..4).map{|i| "inventor_lv#{i}"})).map(&:user).uniq
  end

  def administrators_statuses
    self.user_organization_statuses.where(user: administrators)
  end

  def business_address
    self.addresses.find_by(address_type: 'business')
  end

  def administrators
    self.user_organizations.where(role: Role.find_by(code: 'organization_administrator')).map(&:user).uniq
  end

  def update_business_address(address_params)
    if self.business_address.present?
      self.business_address.update_attributes(address_params)
    else
      self.addresses.create(address_params.merge(address_type: 'business'))
    end
  end

end
