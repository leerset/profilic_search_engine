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
        return data_not_found(MISSING_ORG) if organization.nil?
        user = organization.users.find_by(id: params[:user_id])
        return data_not_found(MISSING_USR) if user.nil?
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
        return data_not_found(MISSING_INV) if invention.nil?
        user = invention.users.find_by(id: params[:user_id])
        return data_not_found(MISSING_USR) if user.nil?
        invention_roles = user.invention_roles(invention)
        resp_ok("invention_roles" => RoleSerializer.build_array(invention_roles))
      end

      desc "user global roles"
      params do
        requires 'user_id', type: Integer, desc: "user_id"
      end
      get :global_roles do
        user = User.find_by(id: params[:user_id])
        return data_not_found(MISSING_USR) if user.nil?
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
        return data_not_found(MISSING_ORG) if organization.nil?
        resp_ok("organization" => OrganizationSerializer.new(organization))
      end

      # desc "get user list"
      # params do
      #   optional :page, type: Integer, desc: 'curent page index，default: 1'
      #   optional :size, type: Integer, desc: 'records count in each page, default: 20'
      # end
      # get :users do
      #   authenticate!
      #   page = params[:page].presence || 1
      #   size = params[:size].presence || 20
      #   if current_user.god?
      #     users = User.all.order(id: :desc).page(page).per(size)
      #     resp_ok("users" => UserSerializer.build_array(users))
      #   elsif current_user.managed_organizations.any?
      #     users = User.includes(:organizations).where(organizations: {id: current_user.managed_organizations.map(&:id)})
      #     users = users.order(id: :desc).page(page).per(size)
      #     resp_ok("users" => UserSerializer.build_array(users, managed_organizations: current_user.managed_organizations))
      #   else
      #     return permission_denied(NOT_GOD_OA_DENIED)
      #   end
      # end

      desc "get Users List Filtering"
      params do
        optional 'name', type: String, desc: "name"
        optional 'organization_id', type: Integer, desc: "organization_id, null for all"
        optional 'status', type: String, desc: "user global status, null for all"
        optional :page, type: Integer, desc: 'curent page index，default: 1'
        optional :size, type: Integer, desc: 'records count in each page, default: 20'
        optional :sort_column, type: String, default: "updated_at", desc: 'sort column default: by updated_time (updated_at)'
        optional :sort_order, type: String, default: "desc", desc: 'sort order (asc for ascending), default: descending'
      end
      get :users do
        authenticate!
        page = params[:page].presence || 1
        size = params[:size].presence || 20
        status = params[:status]
        organization_id = params[:organization_id]
        users = if organization_id.present?
          organization = Organization.find_by(id: organization_id)
          return data_not_found(MISSING_ORG) if organization.nil?
          if current_user.god?
            if status.present? && status.downcase == 'delete'
              User.where(status: ['delete']).includes(:user_organization_statuses).
                where(user_organization_statuses: {organization: organization})
            else
              User.where(status: ['active', 'suspend']).includes(:user_organization_statuses).
                where(user_organization_statuses: {organization: organization})
            end
          else
            global_statuses = current_user.oa?(organization) ? ['active', 'suspend'] : ['active']
            User.where(status: global_statuses).includes(:user_organization_statuses).
              where(user_organization_statuses: {organization: organization, status: ['active', 'inactive']})
          end
        else
          if current_user.god?
            if status.present? && status.downcase == 'delete'
              User.where(status: ['delete'])
            else
              User.where(status: ['active', 'suspend'])
            end
          else
            managed_organizations = current_user.managed_organizations
            only_member_organizations = current_user.only_member_organizations
            users = User.where(status: ['active', 'suspend']).includes(:user_organization_statuses).
              where(user_organization_statuses: {organization_id: managed_organizations.map(&:id), status: ['active', 'inactive']}).
              or(
                User.where(status: ['active']).includes(:user_organization_statuses).
                  where(user_organization_statuses: {organization_id: only_member_organizations.map(&:id), status: ['active']})
              )
          end
        end
        users = users.where(status: status) if status.present?
        if params[:name].present?
          name = params[:name].strip
          nameparts = name.gsub(/\s/,'%')
          users = users.where("LOCATE(?, firstname) OR LOCATE(?, lastname) OR LOCATE(?, email) OR CONCAT(firstname,' ', lastname) LIKE ?", name, name, name, nameparts)
        end
        sortcolumn = User.columns_hash[params[:sort_column]] ? params[:sort_column] : "updated_at"
        sortorder = params[:sort_order] && params[:sort_order].downcase == "asc" ? "asc" : "desc"
        # organizations = current_user.managed_organizations
        users = users.order("users.#{sortcolumn} #{sortorder}").page(page).per(size)
        if current_user.god?
          resp_ok("users" => UserSerializer.build_array(users))
        else
          resp_ok("users" => UserSerializer.build_array(users, managed_organizations: current_user.member_organizations))
        end
      end

      desc "get user"
      params do
        requires :user_id, type: Integer, desc: 'user_id'
      end
      get :user do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return data_not_found(MISSING_USR) if user.nil?
        orgs = (current_user.member_organizations & user.organizations)
        if user == current_user || current_user.god?
          resp_ok("user" => UserEncryptionSerializer.new(user))
        elsif orgs.any?
          resp_ok("user" => UserSerializer.new(user, managed_organizations: current_user.managed_organizations))
        else
          return permission_denied(NOT_GOD_OA_MEMBER_DENIED)
        end
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
