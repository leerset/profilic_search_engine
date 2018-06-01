class CConstruction < ApplicationRecord
  belongs_to :container_section
  ItemNames = %w{ideal_example properties how_made innovative_aspects why_hasnt_done_before}
end
