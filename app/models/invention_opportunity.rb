class InventionOpportunity < ApplicationRecord
  belongs_to :organization
  has_one :invention_opportunity_upload_file
  has_one :upload_file, through: :invention_opportunity_upload_file

  IO_CONTENT_TYPES = [
    'application/msword', 'application/pdf'
  ]


end
