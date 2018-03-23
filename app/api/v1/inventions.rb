module V1
  class Inventions < Grape::API
    version 'v1'
    format :json

    resource :inventions do

      desc "create invention"
      params do
        requires :invention, type: Hash do
          optional :invention_opportunity_id, type: String, desc: "invention_opportunity_id"
          optional :organization_id, type: Integer, desc: "organization_id"
          optional :title, type: String, desc: "title (100)"
          optional :description, type: String, desc: "description (65535)"
          optional :action, type: String, desc: "action (Brainstorm, Solution Report, Sent to Reviewer)"
          optional :action_note, type: String, desc: "action note (500)"
          optional :phase, type: String, default: "phase-1", desc: "phase, e.g. Full Authoring"
          optional :comment_status, default: 'anyone-organization', type: String, desc: "comment_permission generic string value: `anyone-organization`, `only-inventors`, `nobody`"
        end
        optional :scratchpad, type: String, desc: "scratchpad content (65535)"
        optional :searches, type: Array do
          optional :title, type: String, desc: "title"
          optional :url, type: String, desc: "url"
          optional :note, type: String, desc: "note"
          optional :tag, type: String, desc: "tag"
        end
        # optional :co_inventors, type: Array[Integer], desc: "co_inventors id array, e.g. [1,2,3]"
        optional :co_inventors, type: Array do
          optional :user_id, type: Integer, desc: "user_id"
          optional :access, type: Integer, desc: "access level"
        end
        optional :upload, type: File, desc: "upload file"
      end
      post :create do
        authenticate!
        organization_id = params[:invention][:organization_id]
        if organization_id && organization_id.to_i != 0
          organization = Organization.find_by(id: organization_id)
          return data_not_found(MISSING_ORG) if organization.nil?
          return permission_denied(NOT_ORG_USR_DENIED) unless organization.users.include?(current_user)
        else
          params[:invention][:organization_id] = nil
        end
        opportunity_id = params[:invention][:invention_opportunity_id]
        if opportunity_id.present? && opportunity_id.to_i != 0
          invention_opportunity = InventionOpportunity.find_by(id: opportunity_id.to_i)
          return data_not_found(MISSING_IO) if invention_opportunity.nil?
        else
          params[:invention][:invention_opportunity_id] = nil
        end
        permit_invention_params = ActionController::Parameters.new(params[:invention]).permit(
          :invention_opportunity_id, :organization_id,
          :title, :description, :action, :action_note, :phase,
          :comment_status
        )
        invention = Invention.create!(permit_invention_params)
        inventor_role = Role.find_by(role_type: 'invention', code: 'inventor')
        invention.user_inventions.create!(user: current_user, role: inventor_role)
        if (searches = params[:searches]).present?
          searches.each do |search|
            permit_search_params = ActionController::Parameters.new(search).permit(
              :title, :url, :note, :tag
            )
            invention.searches.create!(permit_search_params)
          end
        end
        if (co_inventors = params[:co_inventors]).present?
          co_inventor_role = Role.find_by(role_type: 'invention', code: 'co_inventor')
          co_inventors.each do |co_inventor|
            user = User.find_by_id(co_inventor[:user_id])
            invention.user_inventions.find_or_create_by(user: user).update(
              role: co_inventor_role,
              access: co_inventor[:access]
            ) if user
          end
        end
        if (upload = params[:upload]).present?
          bad_request('upload file type is invalid') unless Invention::IN_CONTENT_TYPES.include?(upload[:type])
          upload_file = UploadFile.create
          upload_file.update_upload(upload)
          invention.upload_files << upload_file
        end
        invention.create_scratchpad!(content: params[:scratchpad])
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
          optional :action_note, type: String, desc: "action note (500)"
          optional :phase, type: String, desc: "phase, e.g. Full Authoring"
          optional :comment_status, default: 'all-organization', type: String, desc: "comment_permission generic string value: `all-organization`, `all-collaborators`"
          optional :archived, type: Boolean, desc: "archived"
        end
        optional :scratchpad, type: String, desc: "scratchpad content (65535)"
        # optional :co_inventors, type: Array[Integer], desc: "co_inventors id array, e.g. [1,2,3]"
        optional :co_inventors, type: Array do
          optional :user_id, type: Integer, desc: "user_id"
          optional :access, type: Integer, desc: "access level"
        end
        optional :upload, type: File, desc: "upload file"
      end
      put :update do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return data_not_found(MISSING_INV) if invention.nil?
        unless current_user.inventor?(invention) || current_user.co_inventor?(invention)
          return permission_denied(NOT_CO_INVENTOR_DENIED)
        end
        ActiveRecord::Base.transaction do
          if params[:invention].present?
            organization_id = params[:invention][:organization_id]
            if organization_id.present? && organization_id.to_i != 0
              organization = Organization.find_by(id: organization_id)
              return data_not_found(MISSING_ORG) if organization.nil?
            else
              params[:invention][:organization_id] = nil
            end
            invention_opportunity_id = params[:invention][:invention_opportunity_id]
            if invention_opportunity_id.present? && invention_opportunity_id.to_i != 0
              invention_opportunity = InventionOpportunity.find_by(id: invention_opportunity_id)
              return data_not_found(MISSING_IO) if invention_opportunity.nil?
            else
              params[:invention][:invention_opportunity_id] = nil
            end
            permit_invention_params = ActionController::Parameters.new(params[:invention]).permit(
              :invention_opportunity_id,
              :organization_id,
              :title, :description, :action, :action_note, :phase,
              :comment_status, :archived
            )
            invention.update_attributes(permit_invention_params)
          end
          if (scratchpad_content = params[:scratchpad]).present?
            scratchpad = invention.scratchpad || invention.create_scratchpad
            scratchpad.update(content: scratchpad_content)
          end
          if (co_inventors = params[:co_inventors]).present?
            co_inventor_role = Role.find_by(role_type: 'invention', code: 'co_inventor')
            invention.user_inventions.where(role: co_inventor_role).where.not(user_id: co_inventors.map{|a| a[:user_id]}).destroy_all
            co_inventors.each do |co_inventor|
              user = User.find_by_id(co_inventor[:user_id])
              invention.user_inventions.find_or_create_by(user: user).update(
                role: co_inventor_role,
                access: co_inventor[:access]
              ) if user
            end
          end
          if (upload = params[:upload]).present?
            bad_request('upload file type is invalid') unless Invention::IN_CONTENT_TYPES.include?(upload[:type])
            upload_file = UploadFile.create
            upload_file.update_upload(upload)
            invention.upload_files << upload_file
          end
        end
        resp_ok("invention" => InventionSerializer.new(invention, user_id: current_user.id))
      end

      desc "update invention phase"
      params do
        requires :invention_id, type: Integer, desc: "invention_id"
        optional :phase, type: String, desc: "phase, e.g. Full Authoring"
      end
      put :update_phase do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return data_not_found(MISSING_INV) if invention.nil?
        unless current_user.inventor?(invention) || current_user.co_inventor?(invention)
          return permission_denied(NOT_CO_INVENTOR_DENIED)
        end
        if params[:phase].present?
          invention.update_attributes(phase: params[:phase])
        else
          invention.update_attributes(phase: nil)
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
        unless current_user.inventor?(invention)
          return permission_denied(NOT_INVENTOR_DENIED)
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
        unless current_user.visible_inventions.include?(invention)
          return permission_denied("No permission to read")
        end
        is_editable = current_user.inventor?(invention) || current_user.co_inventor?(invention)
        resp_ok(
          "invention" => InventionSerializer.new(invention, user_id: current_user.id),
          "is_editable" => is_editable )
      end

      desc "list inventions"
      params do
        optional :archived, type: Boolean, desc: 'archived， if true, show both '
        optional :page, type: Integer, desc: 'curent page index，default: 1'
        optional :size, type: Integer, desc: 'records count in each page, default: 20'
        optional :sort_column, type: String, default: "updated_at", desc: 'sort column default: by updated_time (updated_at)'
        optional :sort_order, type: String, default: "desc", desc: 'sort order (asc for ascending), default: descending'
      end
      get :list do
        authenticate!
        page = params[:page].presence || 1
        size = params[:size].presence || 20
        sortcolumn = Invention.columns_hash[params[:sort_column]] ? params[:sort_column] : "updated_at"
        sortorder = params[:sort_order] && params[:sort_order].downcase == "asc" ? "asc" : "desc"
        # organizations = current_user.managed_organizations
        inventions = current_user.visible_inventions
        paged_inventions = inventions.includes(:users).order("#{sortcolumn} #{sortorder}").page(page).per(size)
        resp_ok("inventions" => InventionSerializer.build_array(paged_inventions, user_id: current_user.id))
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
        paged_user_inventions = user_inventions.order(updated_at: :desc).page(page).per(size)
        resp_ok("participants" => ParticipantSerializer.build_array(paged_user_inventions))
      end

      desc "download invention uploaded file"
      params do
        requires :invention_id, type: Integer, desc: 'invention_opportunity id'
      end
      get :download_uploaded_file do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return data_not_found(MISSING_INV) if invention.nil?
        unless current_user.inventor?(invention) || current_user.co_inventor?(invention)
          return permission_denied(NOT_CO_INVENTOR_DENIED)
        end
        upload_file = invention.upload_file
        return data_not_found(MISSING_FILE) unless upload_file.present? && upload_file.upload.present?
        filename = upload_file.upload_file_name
        content_type upload_file.upload_content_type
        env['api.format'] = :binary
        header 'Content-Disposition', "attachment; filename=#{CGI.escape(filename)}"
        File.open(upload_file.upload.path).read
      end

      desc "add comment"
      params do
        requires :invention_id, type: Integer, desc: "invention_id"
        requires :content, type: String, desc: "content (500)"
      end
      post :add_comment do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return data_not_found(MISSING_INV) if invention.nil?
        case invention.comment_status
        when 'only-organization'
          unless current_user.organization_inventions.include?(invention) || current_user.inventions.include?(invention)
            return permission_denied('No permission to add comments')
          end
        when 'only-collaborators'
          unless current_user.inventions.include?(invention)
            return permission_denied('No permission to add comments')
          end
        else # 'nobody'
          return permission_denied('No permission to add comments')
        end
        invention.comments.create(user: current_user, content: params[:content])
        resp_ok("invention" => InventionSerializer.new(invention, user_id: current_user.id))
      end

      desc "update comment"
      params do
        requires :comment_id, type: Integer, desc: "comment_id"
        requires :content, type: String, desc: "content (500)"
      end
      put :update_comment do
        authenticate!
        comment = Comment.find_by(id: params[:comment_id])
        return data_not_found(MISSING_COMMENT) if comment.nil?
        case invention.comment_status
        when 'only-organization'
          unless current_user.organization_inventions.include?(invention) || current_user.inventions.include?(invention)
            return permission_denied('No permission to update comments')
          end
        when 'only-collaborators'
          unless current_user.inventions.include?(invention)
            return permission_denied('No permission to update comments')
          end
        else # 'nobody'
          return permission_denied('No permission to update comments')
        end
        comment.update(content: params[:content])
        invention = comment.invention
        resp_ok("invention" => InventionSerializer.new(invention, user_id: current_user.id))
      end

      desc "delete comment"
      params do
        requires :comment_id, type: Integer, desc: "comment_id"
      end
      delete :delete_comment do
        authenticate!
        comment = Comment.find_by(id: params[:comment_id])
        return data_not_found(MISSING_COMMENT) if comment.nil?
        unless current_user.inventor?(invention)
          return permission_denied('No permission to delete comments')
        end
        comment.destroy
        resp_ok
      end

      desc "create invention search"
      params do
        requires :invention_id, type: Integer, desc: "invention_id"
        requires :search, type: Hash do
          optional :title, type: String, desc: "title"
          optional :url, type: String, desc: "url"
          optional :note, type: String, desc: "note"
          optional :tag, type: String, desc: "tag"
        end
      end
      post :create_search do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return data_not_found(MISSING_INV) if invention.nil?
        unless current_user.inventor?(invention) || current_user.co_inventor?(invention)
          return permission_denied(NOT_CO_INVENTOR_DENIED)
        end
        permit_search_params = ActionController::Parameters.new(params[:search]).permit(
          :title, :url, :note, :tag
        )
        invention.searches.create!(permit_search_params)
        resp_ok("invention" => InventionSerializer.new(invention, user_id: current_user.id))
      end

      desc "update invention search"
      params do
        requires :search_id, type: Integer, desc: "search_id"
        requires :search, type: Hash do
          optional :title, type: String, desc: "title"
          optional :url, type: String, desc: "url"
          optional :note, type: String, desc: "note"
          optional :tag, type: String, desc: "tag"
        end
      end
      put :update_search do
        authenticate!
        search = Search.find_by(id: params[:search_id])
        return data_not_found(MISSING_SEARCH) if search.nil?
        invention = search.invention
        unless current_user.inventor?(invention) || current_user.co_inventor?(invention)
          return permission_denied(NOT_CO_INVENTOR_DENIED)
        end
        permit_search_params = ActionController::Parameters.new(params[:search]).permit(
          :title, :url, :note, :tag
        )
        search.update(permit_search_params)
        resp_ok("invention" => InventionSerializer.new(invention, user_id: current_user.id))
      end

      desc "delete invention search"
      params do
        requires :search_id, type: Integer, desc: "search_id"
      end
      delete :delete_search do
        authenticate!
        search = Search.find_by(id: params[:search_id])
        return data_not_found(MISSING_SEARCH) if search.nil?
        invention = search.invention
        unless current_user.inventor?(invention) || current_user.co_inventor?(invention)
          return permission_denied(NOT_CO_INVENTOR_DENIED)
        end
        search.destroy
        resp_ok
      end

    end
  end
end
