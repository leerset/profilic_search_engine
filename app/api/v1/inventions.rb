module V1
  class Inventions < Grape::API
    version 'v1'
    format :json

    resource :inventions do

      desc "create invention"
      params do
        requires :invention, type: Hash do
          requires :invention_opportunity_id, type: Integer, desc: "invention_opportunity_id"
          requires :organization_id, type: Integer, desc: "organization_id"
          optional :title, type: String, desc: "title (100)"
          optional :description, type: String, desc: "description (200)"
        end
        optional :co_inventors, type: Array, desc: "co_inventors id array, e.g. [1,2,3]"
        optional :uploads, type: Array[File], desc: "upload files"
      end
      post :create do
        authenticate!
        organization = Organization.find_by(id: params[:organization_id])
        return data_not_found(MISSING_ORG) if organization.nil?
        return permission_denied(NOT_ORG_USR_DENIED) unless organization.users.include?(current_user)
        invention_opportunity = InventionOpportunity.find_by(id: params[:invention_opportunity_id])
        return data_not_found(MISSING_IO) if invention_opportunity.nil?
        permit_invention_params = ActionController::Parameters.new(params[:invention]).permit(
          :invention_opportunity_id, :organization_id, :title, :description
        )
        invention = Invention.create_by(permit_invention_params)
        inventor_role = Role.find_by(role_type: 'invention', code: 'inventor')
        invention.user_inventions.create(user: current_user, role: inventor_role)
        if (co_inventor_ids = params[:co_inventors]).present?
          co_inventor_role = Role.find_by(role_type: 'invention', code: 'co-inventor')
          (co_inventor_ids.uniq - [current_user.id]).each do |co_inventor_id|
            co_inventor = User.find_by_id(co_inventor_id)
            invention.user_inventions.create(user: co_inventor, role: co_inventor_role) if co_inventor
          end
        end
        if (uploads = params[:uploads]).present?
          uploads.each do |upload|
            bad_request('upload file type is invalid') unless Invention::IN_CONTENT_TYPES.include?(upload[:type])
            upload_file = UploadFile.create
            upload_file.update_upload(upload)
            invention.invention_upload_files.find_or_create_by(upload_file: upload_file)
          end
        end
        resp_ok("invention" => InventionSerializer.new(invention))
      end

      desc "delete invention"
      params do
        requires :invention_id, type: Integer, desc: "invention_id"
      end
      delete :delete do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return data_not_found(MISSING_INV) if invention.nil?
        unless current_user.god? || current_user.inventor?(invention)
          return permission_denied(NOT_GOD_INVENTOR_DENIED)
        end
        invention.destroy
        resp_ok
      end

      desc "detail invention"
      params do
        requires :invention_id, type: Integer, desc: "invention_id"
      end
      get :detail do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return data_not_found(MISSING_INV) if invention.nil?
        unless current_user.god? || current_user.inventor?(invention) || current_user.co_inventor?(invention)
          return permission_denied(NOT_GOD_INVENTOR_DENIED)
        end
        resp_ok("invention" => InventionSerializer.new(invention))
      end

      desc "list inventions"
      params do
        optional :page, type: Integer, desc: 'curent page index，default: 1'
        optional :size, type: Integer, desc: 'records count in each page, default: 20'
      end
      get :list do
        authenticate!
        page = params[:page].presence || 1
        size = params[:size].presence || 20
        organizations = current_user.managed_organizations
        inventions = if current_user.god?
          Invention.all
        elsif organizations.any?
          Invention.where(organization: organizations)
        else
          current_user.inventions
        end
        paged_inventions = inventions.order(id: :desc).page(page).per(size)
        resp_ok("inventions" => InventionListSerializer.build_array(paged_inventions))
      end

      desc "list participants"
      params do
        requires :invention_id, type: Integer, desc: "invention_id"
        optional :page, type: Integer, desc: 'curent page index，default: 1'
        optional :size, type: Integer, desc: 'records count in each page, default: 20'
      end
      get :participants do
        page = params[:page].presence || 1
        size = params[:size].presence || 20
        invention = Invention.find_by(id: params[:invention_id])
        return data_not_found(MISSING_INV) if invention.nil?
        user_inventions = invention.user_inventions
        paged_user_inventions = user_inventions.order(id: :desc).page(page).per(size)
        resp_ok("participants" => ParticipantSerializer.build_array(paged_user_inventions))
      end

    end
  end
end
