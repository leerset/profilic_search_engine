class CComparativeadvantage < ApplicationRecord
  belongs_to :container_section
  ItemNames = %w{competing_howworks shortcomings howovercomes_shortcomings}
end
