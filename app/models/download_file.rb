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
    original_file_name = download_file[:filename]
    ext_name = original_file_name[/\.[^\.]+$/]
    self.download_file_name = generate_filename(ext_name)
    self.download.save
    self.filepath = self.download.path
    self.save!
  end

  def download_url
    return nil if self.download.nil?
    Settings.backend_host + self.download.url
  end

  def generate_filename(ext_name = '')
    begin
      filename = "#{SecureRandom.hex(12)}#{ext_name}"
    end while DownloadFile.where(download_file_name: filename).exists?
    filename
  end

end
