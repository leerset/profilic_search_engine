class UserInvention < ApplicationRecord
  belongs_to :user
  belongs_to :invention
  belongs_to :role, optional: true
end
