class UploadFile < ApplicationRecord

  has_many :invention_upload_files, optional: true, dependent: :destroy
  has_many :invention_opportunity_upload_files, optional: true, dependent: :destroy

  UPLOAD_CONTENT_TYPES = [
    'image/png',
    'image/jpeg',
    'text/plain',
    'audio/mpeg',
    'audio/mp3',
    'application/pdf',
    'application/xlsx',
    #.doc
    'application/msword',
    #.dot
    'application/msword',
    #.docx
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    #.dotx
    'application/vnd.openxmlformats-officedocument.wordprocessingml.template',
    #.docm
    'application/vnd.ms-word.document.macroEnabled.12',
    #.dotm
    'application/vnd.ms-word.template.macroEnabled.12',
    #.xls
    'application/vnd.ms-excel',
    #.xlt
    'application/vnd.ms-excel',
    #.xla
    'application/vnd.ms-excel',
    #.xlsx
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    #.xltx
    'application/vnd.openxmlformats-officedocument.spreadsheetml.template',
    #.xlsm
    'application/vnd.ms-excel.sheet.macroEnabled.12',
    #.xltm
    'application/vnd.ms-excel.template.macroEnabled.12',
    #.xlam
    'application/vnd.ms-excel.addin.macroEnabled.12',
    #.xlsb
    'application/vnd.ms-excel.sheet.binary.macroEnabled.12',
    #.ppt
    'application/vnd.ms-powerpoint',
    #.pot
    'application/vnd.ms-powerpoint',
    #.pps
    'application/vnd.ms-powerpoint',
    #.ppa
    'application/vnd.ms-powerpoint',
    #.pptx
    'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    #.potx
    'application/vnd.openxmlformats-officedocument.presentationml.template',
    #.ppsx
    'application/vnd.openxmlformats-officedocument.presentationml.slideshow',
    #.ppam
    'application/vnd.ms-powerpoint.addin.macroEnabled.12',
    #.pptm
    'application/vnd.ms-powerpoint.presentation.macroEnabled.12',
    #.potm
    'application/vnd.ms-powerpoint.presentation.macroEnabled.12',
    #.ppsm
    'application/vnd.ms-powerpoint.slideshow.macroEnabled.12'
  ]

  has_attached_file :upload,
    path: ':rails_root/upload/:id/:filename',
    url: '/upload/:id/:filename'
  validates_attachment_content_type :upload,
    :content_type => UPLOAD_CONTENT_TYPES

  def update_upload(upload_file)
    # resume_file[:type]
    # resume_file[:tempfile]
    self.upload = upload_file[:tempfile]
    self.upload_file_name = upload_file[:filename]
    self.upload.save
    self.filepath = self.upload.path
    self.save!
  end

end
