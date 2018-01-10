module V1
  class Inventions < Grape::API
    version 'v1'
    format :json

    resource :inventions do

      desc "create invention"
      params do
        requires :organization_id, type: Integer, desc: "organization_id"
        requires :name, type: String, desc: "name"
      end
      post :create do
        authenticate!
        organization = Organization.find_by(id: params[:organization_id])
        return resp_error(MISSING_ORG) if organization.nil?
        return resp_error(NOT_ORG_USR_DENIED) unless organization.users.include?(current_user)
        invention = organization.inventions.create(name: params[:name])
        inventor_role = Role.find_by(role_type: 'invention', code: 'inventor')
        invention.user_inventions.create(user: current_user, role: inventor_role)
        resp_ok("invention" => InventionSerializer.new(invention))
      end

      desc "delete invention"
      params do
        requires :invention_id, type: Integer, desc: "invention_id"
      end
      delete :delete do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return resp_error(MISSING_INV) if invention.nil?
        unless current_user.god? || current_user.inventor?(invention)
          return resp_error(NOT_GOD_INVENTOR_DENIED)
        end
        invention.destroy
        resp_ok
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
        organizations = current_user.user_organizations.
          where(role: Role.find_by(role_type: 'organization', code: 'organization_administrator')).
          map(&:organization)
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
        return resp_error(MISSING_INV) if invention.nil?
        user_inventions = invention.user_inventions
        paged_user_inventions = user_inventions.order(id: :desc).page(page).per(size)
        resp_ok("participants" => ParticipantSerializer.build_array(paged_user_inventions))
      end

    end
  end
end
