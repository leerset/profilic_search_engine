class Citizenship < ApplicationRecord
  has_many :user_citizenships
  has_many :users, through: :user_citizenships
end
