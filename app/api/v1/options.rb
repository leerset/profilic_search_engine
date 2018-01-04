module V1
  class Options < Grape::API
    version 'v1'
    format :json

    resource :options do

      desc "get role list"
      params do
        optional :role_type, type: String, values: ['global', 'invention', 'organization'], desc: 'role type'
      end
      get :roles do
        role_type = params[:role_type]
        roles = if role_type.present?
          Role.where(role_type: role_type)
        else
          Role.where(role_type: ['global', 'invention', 'organization'])
        end
        resp_ok("roles" => RoleSerializer.build_array(roles))
      end

      desc "user organization roles"
      params do
        requires 'organization_id', type: Integer, desc: "organization id"
        requires 'user_id', type: Integer, desc: "user_id"
      end
      get :organization_roles do
        organization = Organization.find_by(id: params[:organization_id])
        return resp_error(MISSING_ORG) if organization.nil?
        user = organization.users.find_by(id: params[:user_id])
        return resp_error(MISSING_USR) if user.nil?
        organization_roles = user.organization_roles(organization)
        resp_ok("organization_roles" => RoleSerializer.build_array(organization_roles))
      end

      desc "user invention roles"
      params do
        requires 'invention_id', type: Integer, desc: "invention id"
        requires 'user_id', type: Integer, desc: "user_id"
      end
      get :invention_roles do
        invention = Invention.find_by(id: params[:invention_id])
        return resp_error(MISSING_INV) if invention.nil?
        user = invention.users.find_by(id: params[:user_id])
        return resp_error(MISSING_USR) if user.nil?
        invention_roles = user.invention_roles(invention)
        resp_ok("invention_roles" => RoleSerializer.build_array(invention_roles))
      end

      desc "user global roles"
      params do
        requires 'user_id', type: Integer, desc: "user_id"
      end
      get :global_roles do
        user = User.find_by(id: params[:user_id])
        return resp_error(MISSING_USR) if user.nil?
        resp_ok("global_roles" => RoleSerializer.build_array(user.roles))
      end

      desc "get organization list"
      params do
        optional :page, type: Integer, desc: 'curent page index，default: 1'
        optional :size, type: Integer, desc: 'records count in each page, default: 20'
      end
      get :organizations do
        page = params[:page].presence || 1
        size = params[:size].presence || 20
        organizations = Organization.all.order(id: :desc).page(page).per(size)
        resp_ok("organizations" => OrganizationSerializer.build_array(organizations))
      end

      desc "get organization"
      params do
        requires :organization_id, type: Integer, desc: 'organization id'
      end
      get :organization do
        organization = Organization.find_by(id: params[:organization_id])
        return service_error(MISSING_ORG) if organization.nil?
        resp_ok("organization" => OrganizationSerializer.new(organization))
      end

      desc "get user list"
      params do
        optional :page, type: Integer, desc: 'curent page index，default: 1'
        optional :size, type: Integer, desc: 'records count in each page, default: 20'
      end
      get :users do
        page = params[:page].presence || 1
        size = params[:size].presence || 20
        users = User.all.order(id: :desc).page(page).per(size)
        resp_ok("users" => UserSerializer.build_array(users))
      end

      desc "get user"
      params do
        requires :user_id, type: Integer, desc: 'user_id'
      end
      get :user do
        user = User.find_by(id: params[:user_id])
        return service_error('void user') if user.nil?
        resp_ok("user" => UserSerializer.new(user))
      end

      desc "get citizenships"
      params do
      end
      get :citizenships do
        citizenships = Citizenship.all
        resp_ok("citizenships" => CitizenshipSerializer.build_array(citizenships))
      end

      desc "get languages"
      params do
      end
      get :languages do
        languages = Language.all
        resp_ok("languages" => LanguageSerializer.build_array(languages))
      end

      # desc "get time_zones"
      # params do
      # end
      # get :time_zones do
      #   time_zones = TimeZone.all
      #   resp_ok("time_zones" => TimeZoneSerializer.build_array(time_zones))
      # end

    end
  end
end
