module V1
  class UploadFiles < Grape::API
    version 'v1'
    default_format :json

    resource :upload_files do

      desc "download upload file"
      params do
        requires :id, type: Integer, desc: 'upload_file id'
      end
      get :download do
        authenticate!
        upload_file = UploadFile.find_by(id: params[:id])
        return data_not_found(MISSING_FILE) unless upload_file.present? && upload_file.upload.present?
        filename = upload_file.upload_file_name
        content_type upload_file.upload_content_type
        env['api.format'] = :binary
        header 'Content-Disposition', "attachment; filename=#{CGI.escape(filename)}"
        File.open(upload_file.upload.path).read
      end

      desc "delete upload file"
      params do
        requires :id, type: Integer, desc: 'upload file id'
      end
      delete :delete do
        authenticate!
        upload_file = UploadFile.find_by(id: params[:id])
        return data_not_found(MISSING_FILE) unless upload_file.present? && upload_file.upload.present?
        upload_file.destroy!
        resp_ok(message: 'upload file deleted')
      end

    end
  end
end
