class Search < ApplicationRecord
  has_one :invention_search
  has_one :invention, through: :invention_search
end
