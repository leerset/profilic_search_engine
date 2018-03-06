class UploadFileSerializer < ActiveModel::Serializer
  attributes :id, :upload_file_name, :upload_content_type, :upload_file_size, :created_time, :updated_time

  def created_time
    object.created_at.to_i
  end

  def updated_time
    object.updated_at.to_i
  end

end
