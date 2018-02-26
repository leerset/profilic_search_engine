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
          optional :action, type: String, desc: "action (Brainstorm, Solution Report, Sent to Reviewer)"
        end
        optional :co_inventors, type: Array, desc: "co_inventors id array, e.g. [1,2,3]"
        optional :upload, type: File, desc: "upload file"
      end
      post :create do
        authenticate!
        organization = Organization.find_by(id: params[:organization_id])
        return data_not_found(MISSING_ORG) if organization.nil?
        return permission_denied(NOT_ORG_USR_DENIED) unless organization.users.include?(current_user)
        invention_opportunity = InventionOpportunity.find_by(id: params[:invention_opportunity_id])
        return data_not_found(MISSING_IO) if invention_opportunity.nil?
        permit_invention_params = ActionController::Parameters.new(params[:invention]).permit(
          :invention_opportunity_id, :organization_id, :title, :description, :action
        )
        invention = Invention.create_by(permit_invention_params)
        inventor_role = Role.find_by(role_type: 'invention', code: 'inventor')
        invention.user_inventions.create(user: current_user, role: inventor_role)
        if (co_inventor_ids = params[:co_inventors]).present?
          co_inventor_role = Role.find_by(role_type: 'invention', code: 'co-inventor')
          co_inventor_ids.uniq.each do |co_inventor_id|
            co_inventor = User.find_by_id(co_inventor_id)
            invention.user_inventions.find_or_create_by(user: co_inventor, role: co_inventor_role) if co_inventor
          end
        end
        if (upload = params[:upload]).present?
          bad_request('upload file type is invalid') unless Invention::IN_CONTENT_TYPES.include?(upload[:type])
          upload_file = UploadFile.create
          upload_file.update_upload(upload)
          invention.invention_upload_files.find_or_create_by(upload_file: upload_file)
        end
        resp_ok("invention" => InventionSerializer.new(invention, user_id: current_user.id))
      end

      desc "update invention"
      params do
        requires :invention_id, type: Integer, desc: "invention_id"
        optional :invention, type: Hash do
          optional :invention_opportunity_id, type: Integer, desc: "invention_opportunity_id"
          optional :organization_id, type: Integer, desc: "organization_id"
          optional :title, type: String, desc: "title (100)"
          optional :description, type: String, desc: "description (200)"
          optional :action, type: String, desc: "action (Brainstorm, Solution Report, Sent to Reviewer)"
        end
        optional :co_inventors, type: Array, desc: "co_inventors id array, e.g. [1,2,3]"
        optional :upload, type: File, desc: "upload file"
      end
      post :update do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return data_not_found(MISSING_INV) if invention.nil?
        unless current_user.god? || current_user.inventor?(invention)
          return permission_denied(NOT_GOD_INVENTOR_DENIED)
        end
        ActiveRecord::Base.transaction do
          if params[:invention].present?
            if params[:invention][:organization_id].present?
              organization = Organization.find_by(id: params[:invention][:organization_id])
              return data_not_found(MISSING_ORG) if organization.nil?
            end
            if params[:invention][:invention_opportunity_id].present?
              invention_opportunity = InventionOpportunity.find_by(id: params[:invention][:invention_opportunity_id])
              return data_not_found(MISSING_IO) if invention_opportunity.nil?
            end
            permit_invention_params = ActionController::Parameters.new(params[:invention]).permit(
              :invention_opportunity_id, :organization_id, :title, :description, :action
            )
            invention.update_attributes(permit_invention_params)
          end
          if (co_inventor_ids = params[:co_inventors]).present?
            co_inventor_role = Role.find_by(role_type: 'invention', code: 'co-inventor')
            invention.user_invetions.where(role: co_inventor_role).where.not(user_id: [co_inventor_ids]).destroy_all
            co_inventor_ids.uniq.each do |co_inventor_id|
              co_inventor = User.find_by_id(co_inventor_id)
              invention.user_inventions.find_or_create_by(user: co_inventor, role: co_inventor_role) if co_inventor
            end
          end
          if (upload = params[:upload]).present?
            bad_request('upload file type is invalid') unless Invention::IN_CONTENT_TYPES.include?(upload[:type])
            upload_file = UploadFile.create
            upload_file.update_upload(upload)
            invention.invention_upload_files.find_or_create_by(upload_file: upload_file)
          end
        end
        resp_ok("invention" => InventionSerializer.new(invention, user_id: current_user.id))
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
        resp_ok("invention" => InventionSerializer.new(invention, user_id: current_user.id))
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
        resp_ok("inventions" => InventionListSerializer.build_array(paged_inventions, user_id: current_user.id))
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
