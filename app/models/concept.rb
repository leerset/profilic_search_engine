class Concept < ApplicationRecord
  has_paper_trail only: [:summary]

  belongs_to :user
  has_many :solutions

  searchable do
    text    :summary
    integer :user_id
    time    :created_at
    time    :updated_at
  end
end
