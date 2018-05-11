class DownloadFile < ApplicationRecord

  CONTENT_TYPES = [
    'image/png',
    'image/jpeg'
  ]

  has_attached_file :download,
    path: ':rails_root/download/:filename',
    url: '/download/:filename'
  validates_attachment_content_type :download,
    :content_type => CONTENT_TYPES

  def update_download(download_file)
    # resume_file[:type]
    # resume_file[:tempfile]
    self.download = download_file[:tempfile]
    self.download_file_name = download_file[:filename]
    self.download.save
    self.filepath = self.download.path
    self.save!
  end

end
