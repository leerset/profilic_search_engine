class Solution < ApplicationRecord
  has_paper_trail only: [:summary, :significance]

  belongs_to :concept
  searchable do
    text :summary, :significance
  end
end
