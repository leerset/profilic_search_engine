module V1
  class InventionOpportunities < Grape::API
    version 'v1'
    default_format :json

    resource :invention_opportunities do

      desc "create invention opportunity"
      params do
        requires :organization_id, type: Integer, desc: "organization_id"
        requires :invention_opportunity, type: Hash do
          requires :title, type: String, desc: "OPPORTUNITY TITLE"
          requires :closing_date, type: Integer, desc: "EXPIRES: closing_date (timestamp)"
          requires :short_description, type: String, desc: "STREET: short_description"
          optional :status, type: String, desc: "STATUS"
        end
        optional :upload, type: File, desc: "upload file"
      end
      post :create do
        authenticate!
        organization = Organization.find_by(id: params[:organization_id])
        return data_not_found(MISSING_ORG) if organization.nil?
        return permission_denied(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(organization)
        invention_opportunity = organization.invention_opportunities.find_by(title: params[:invention_opportunity][:title])
        return data_exist(EXIST_IO_TITLE) if invention_opportunity.present?
        close_date_timestamp = params[:invention_opportunity][:closing_date]
        params[:invention_opportunity][:closing_date] = (Time.new('1970-01-01') + close_date_timestamp).to_date
        ActiveRecord::Base.transaction do
          permit_io_params = ActionController::Parameters.new(params[:invention_opportunity]).permit(
            :title, :closing_date, :short_description, :status
          )
          invention_opportunity = organization.invention_opportunities.create!(permit_io_params)
          if (upload = params[:upload]).present?
            bad_request('upload file type is invalid') unless InventionOpportunity::IO_CONTENT_TYPES.include?(upload[:type])
            upload_file = UploadFile.create
            upload_file.update_upload(upload)
            invention_opportunity.update(upload_file: upload_file)
          end
        end
        resp_ok("invention_opportunity" => InventionOpportunitySerializer.new(invention_opportunity))
      end

      desc "update invention opportunity"
      params do
        requires :invention_opportunity_id, type: Integer, desc: "invention_opportunity id"
        optional :invention_opportunity, type: Hash do
          optional :title, type: String, desc: "OPPORTUNITY TITLE"
          optional :closing_date, type: Integer, desc: "EXPIRES: closing_date (timestamp)"
          optional :short_description, type: String, desc: "STREET: short_description"
          optional :status, type: String, desc: "STATUS"
        end
        optional :upload, type: File, desc: "upload file"
      end
      put :update do
        authenticate!
        invention_opportunity = InventionOpportunity.find_by(id: params[:invention_opportunity_id])
        return data_not_found(MISSING_IO) if invention_opportunity.nil?
        organization = invention_opportunity.organization
        return permission_denied(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(organization)
        close_date_timestamp = params[:invention_opportunity][:closing_date]
        if close_date_timestamp.present?
          params[:invention_opportunity][:closing_date] = (Time.new('1970-01-01') + close_date_timestamp).to_date
        end
        ActiveRecord::Base.transaction do
          if params[:invention_opportunity].present?
            permit_io_params = ActionController::Parameters.new(params[:invention_opportunity]).permit(
              :title, :closing_date, :short_description, :status
            )
            invention_opportunity.update_attributes(permit_io_params)
          end
          if (upload = params[:upload]).present?
            bad_request('upload file type is invalid') unless InventionOpportunity::IO_CONTENT_TYPES.include?(upload[:type])
            upload_file = UploadFile.create
            upload_file.update_upload(upload)
            invention_opportunity.update(upload_file: upload_file)
          end
        end
        resp_ok("invention_opportunity" => InventionOpportunitySerializer.new(invention_opportunity))
      end

      desc "filter list invention opportunities"
      params do
        optional :organization_id, type: Integer, desc: "organization_id"
        optional :status, type: String, desc: "status"
        optional :page, type: Integer, desc: 'curent page index, default: 1'
        optional :size, type: Integer, desc: 'records count in each page, default: 20'
        optional :sort_column, type: String, desc: 'sort column default: by id'
        optional :sort_order, type: String, desc: 'sort order (desc for descending), default: ascending'
      end
      get :list do
        authenticate!
        page = params[:page].presence || 1
        size = params[:size].presence || 20
        sortcolumn = InventionOpportunity.columns_hash[params[:sort_column]] ? params[:sort_column] : "id"
        sortorder = params[:sort_order] && params[:sort_order].downcase == "desc" ? "desc" : nil
        organizations = []
        if params[:organization_id].present?
          organizations = Organization.where(id: params[:organization_id])
          return data_not_found(MISSING_ORG) if organizations.empty?
          return permission_denied(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(organization)
        end
        if organizations.any?
          organizations &= current_user.managed_organizations
        else
          organizations = current_user.managed_organizations
        end
        invention_opportunities = if params[:status]
          InventionOpportunity.where(organization: organizations, status: params[:status])
        else
          InventionOpportunity.where(organization: organizations)
        end
        paged_invention_opportunities = invention_opportunities.order("status, #{sortcolumn} #{sortorder}").page(page).per(size)
        resp_ok("invention_opportunities" => InventionOpportunitySerializer.build_array(paged_invention_opportunities))
      end

      desc "detail invention opportunity"
      params do
        requires :invention_opportunity_id, type: Integer, desc: "invention_opportunity id"
      end
      get :detail do
        authenticate!
        invention_opportunity = InventionOpportunity.find_by(id: params[:invention_opportunity_id])
        return data_not_found(MISSING_IO) if invention_opportunity.nil?
        organization = invention_opportunity.organization
        return permission_denied(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(organization)
        resp_ok("invention_opportunity" => InventionOpportunitySerializer.new(invention_opportunity))
      end

      desc "delete invention opportunity"
      params do
        requires :invention_opportunity_id, type: Integer, desc: 'invention_opportunity id'
      end
      delete :delete do
        authenticate!
        invention_opportunity = InventionOpportunity.find_by(id: params[:invention_opportunity_id])
        return data_not_found(MISSING_IO) if invention_opportunity.nil?
        return permission_denied(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(organization)
        invention_opportunity.destroy!
        resp_ok(message: 'invention opportunity deleted')
      end

      desc "download invention opportunity uploaded file"
      params do
        requires :invention_opportunity_id, type: Integer, desc: 'invention_opportunity id'
      end
      get :download_uploaded_file do
        authenticate!
        invention_opportunity = InventionOpportunity.find_by(id: params[:invention_opportunity_id])
        return data_not_found(MISSING_IO) if invention_opportunity.nil?
        return permission_denied(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(organization)
        upload_file = invention_opportunity.upload_file
        return data_not_found(MISSING_FILE) unless upload_file.present? && upload_file.upload.present?
        filename = upload_file.upload_file_name
        content_type upload_file.upload_content_type
        env['api.format'] = :binary
        header 'Content-Disposition', "attachment; filename=#{CGI.escape(filename)}"
        File.open(upload_file.upload.path).read
      end

      desc "test download invention opportunity uploaded file"
      params do
        requires :invention_opportunity_id, type: Integer, desc: 'invention_opportunity id'
      end
      get :download_test do
        invention_opportunity = InventionOpportunity.find_by(id: params[:invention_opportunity_id])
        return data_not_found(MISSING_IO) if invention_opportunity.nil?
        upload_file = invention_opportunity.upload_file
        return data_not_found(MISSING_FILE) unless upload_file.present? && upload_file.upload.present?
        filename = upload_file.upload_file_name
        content_type upload_file.upload_content_type
        env['api.format'] = :binary
        header 'Content-Disposition', "attachment; filename=#{CGI.escape(filename)}"
        File.open(upload_file.upload.path).read
      end

    end
  end
end
