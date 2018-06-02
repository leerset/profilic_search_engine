class CDevelopment < ApplicationRecord
  belongs_to :container_section
  ItemNames = %w{title key_points resources_needed deliverables measure_of_success key_risks suggested_approach}
end
