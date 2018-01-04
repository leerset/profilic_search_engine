class Address < ApplicationRecord
  has_many :user_addresses
  has_many :users, through: :user_addresses
  has_many :organization_addresses
  has_many :organizations, through: :organization_addresses
  has_many :phones
end
