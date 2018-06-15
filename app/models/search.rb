class Search < ApplicationRecord
  has_one :invention_search, dependent: :destroy
  has_one :invention, through: :invention_search
end
