class UploadFile < ApplicationRecord
  UPLOAD_CONTENT_TYPES = [
    # 'image/png', 'image/jpeg',
    # 'text/plain',
    # 'audio/mpeg', 'audio/mp3',
    'application/msword', 'application/pdf', 'application/xlsx'
  ]

  has_attached_file :upload,
    path: ':rails_root/upload/:id/:filename',
    url: '/upload/:id/:filename'
  validates_attachment_content_type :upload,
    :content_type => UPLOAD_CONTENT_TYPES

  def update_upload(upload_file)
    # resume_file[:filename]
    # resume_file[:type]
    # resume_file[:tempfile]
    self.upload = upload_file[:tempfile]
    self.upload.save
    self.filepath = self.upload.path
    self.save!
  end

end
