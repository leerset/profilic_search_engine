module V1
  class Organizations < Grape::API
    version 'v1'
    format :json

    resource :organizations do

      desc "get organization list"
      params do
        optional :page, type: Integer, desc: 'curent page index，default: 1'
        optional :size, type: Integer, desc: 'records count in each page, default: 20'
      end
      get :list do
        # authenticate!
        page = params[:page].presence || 1
        size = params[:size].presence || 20
        organizations = Organization.all.order(id: :desc).page(page).per(size)
        resp_ok("organizations" => OrganizationSerializer.build_array(organizations))
      end

      desc "get organization"
      params do
        requires :organization_id, type: Integer, desc: 'organization id'
      end
      get :detail do
        # authenticate!
        organization = Organization.find_by(id: params[:organization_id])
        return resp_error('void organization') if organization.nil?
        resp_ok("organization" => OrganizationSerializer.new(organization))
      end

      desc "create organization"
      params do
        requires 'organization', type: Hash do
          requires 'name', type: String, desc: "name"
          optional 'code', type: String, desc: "code"
          optional 'time_zone', type: String, desc: "time_zone"
          optional 'summary', type: String, desc: "summary"
        end
      end
      post :create do
        authenticate!
        organization_name = params[:organization][:name].strip
        organization = Organization.find_by(name: organization_name)
        return resp_error('organization name already exist.') if organization.present?
        permit_organization_params = ActionController::Parameters.new(params[:organization]).permit(
          :name, :code, :city, :time_zone, :summary
        )
        new_organization = Organization.find_or_create_by(permit_organization_params)
        current_user.user_organizations.find_or_create_by(organization: new_organization, role: Role.find_by(name: 'creator'))
        resp_ok("organization" => OrganizationSerializer.new(new_organization))
      end

      desc "update organization"
      params do
        requires :organization_id, type: Integer, desc: 'organization id'
        requires 'organization', type: Hash do
          optional 'name', type: String, desc: "name"
          optional 'code', type: String, desc: "code"
          optional 'time_zone', type: String, desc: "time_zone"
          optional 'summary', type: String, desc: "summary"
        end
      end
      post :update do
        authenticate!
        organization = Organization.find_by(id: params[:organization_id])
        return resp_error('void organization') if organization.nil?
        return resp_error('no permission to update the organization') if current_user != organization.creator
        permit_organization_params = ActionController::Parameters.new(params[:organization]).permit(
          :name, :code, :city, :time_zone, :summary
        )
        organization.update(permit_organization_params)
        resp_ok("organization" => OrganizationSerializer.new(organization))
      end

    end
  end
end
