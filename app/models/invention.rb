class Invention < ApplicationRecord
  belongs_to :organization
  has_many :user_inventions
  has_many :users, through: :user_inventions
end
