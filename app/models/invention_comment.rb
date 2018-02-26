class InventionComment < ApplicationRecord
  belongs_to :invention
  belongs_to :comment
end
