class Comment < ApplicationRecord
  belongs_to :user
  has_one :invention_comment
  has_one :invention, through: :invention_comment
  has_one :container_section_comment
  has_one :container_section, through: :container_section_comment
end
