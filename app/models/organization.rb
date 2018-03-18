class Organization < ApplicationRecord
  has_many :user_organizations
  has_many :users, through: :user_organizations
  has_many :inventions

  has_many :organization_addresses
  has_many :addresses, through: :organization_addresses

  has_many :user_organization_statuses
  has_many :invention_opportunities

  def inventors
    user_organizations.includes(:user).where(role: Role.find_by(code: (1..4).map{|i| "inventor_lv#{i}"})).map(&:user).uniq
  end

  def administrators_statuses
    user_organization_statuses.where(user: administrators)
  end

  def business_address
    addresses.select {|a| a.address_type == 'business'}[0]
  end

  def administrators
    user_organizations.includes(:user).where(role: Role.find_by(code: 'organization_administrator')).map(&:user).uniq
  end

  def members
    user_organizations.includes(:user).where(role: Role.find_by(code: 'organization_member')).map(&:user).uniq
  end

  def update_business_address(address_params)
    if business_address.present?
      business_address.update_attributes(address_params)
    else
      addresses.create(address_params.merge(address_type: 'business'))
    end
  end

end
