class InventionOpportunityUploadFile < ApplicationRecord
  belongs_to :invention_opportunity
  belongs_to :upload_file
end
