class InventionOpportunity < ApplicationRecord
  belongs_to :organization, optional: true
  has_one :invention_opportunity_upload_file, dependent: :destroy
  has_one :upload_file, through: :invention_opportunity_upload_file

  OTHER = self.find_by_id(-1) || self.create(
    id: -1,
    title: 'Other',
    closing_date: '2088-01-01',
    short_description: 'Other',
    status: 'Active'
  )

  IO_CONTENT_TYPES = [
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/pdf'
  ]

end
