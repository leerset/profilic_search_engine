class UserCitizenship < ApplicationRecord
  belongs_to :user
  belongs_to :citizenship
end
