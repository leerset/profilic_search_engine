class InventionUploadFile < ApplicationRecord
  belongs_to :invention
  belongs_to :upload_file
end
