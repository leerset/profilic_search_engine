module V1
  class DownloadFiles < Grape::API
    version 'v1'
    default_format :json

    resource :download_files do

      desc "upload file"
      params do
        requires :file, type: File, desc: "upload image file (png, jpeg)"
      end
      put :upload do
        file = params[:file]
        bad_request('upload file type is invalid') unless DownloadFile::CONTENT_TYPES.include?(file[:type])
        download_file = DownloadFile.create
        download_file.update_download(file)
        {link: download_file.download_url}
      end

    end
  end
end
