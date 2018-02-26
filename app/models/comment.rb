class Comment < ApplicationRecord
  belongs_to :user
  has_one :invention_comment
  has_one :invention, through: :invention_comment
end
