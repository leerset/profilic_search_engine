module V1
  class UserRoles < Grape::API
    version 'v1'
    format :json

    resource :user_roles do

#### global

      desc "add user global role (user type)"
      params do
        requires 'user_id', type: Integer, desc: "user_id"
        requires 'role_id', type: Integer, desc: "new user role id"
      end
      post :add_global_role do
        authenticate!
        return resp_error(NOT_GOD_DENIED) unless current_user.god?
        user = User.find_by(id: params[:user_id])
        return resp_error(MISSING_USR) if user.nil?
        role = Role.find_by(id: params[:role_id], role_type: 'global')
        return resp_error(MISSING_ROL) if role.nil?
        user.user_roles.find_or_create_by(role_id: role.id)
        resp_ok("user_roles" => UserRoleSerializer.build_array(user.user_roles))
      end

      desc "change user global role (user type)"
      params do
        requires 'user_role_id', type: Integer, desc: "user_role id"
        requires 'role_id', type: Integer, desc: "new user role id"
      end
      post :change_global_role do
        authenticate!
        return resp_error(NOT_GOD_DENIED) unless current_user.god?
        user_role = UserRole.find_by(id: params[:user_role_id])
        return resp_error(MISSING_USR_ROL) if user_role.nil?
        role = Role.find_by(id: params[:role_id], role_type: 'global')
        return resp_error(MISSING_ROL) if role.nil?
        user_role.update_attributes(role_id: role.id)
        resp_ok("user_role" => UserRoleSerializer.new(user_role))
      end

      desc "delete user global role (user type)"
      params do
        requires 'user_role_id', type: Integer, desc: "user_role id"
      end
      post :delete_global_role do
        authenticate!
        return resp_error(NOT_GOD_DENIED) unless current_user.god?
        user_role = UserRole.find_by(id: params[:user_role_id])
        return resp_error(MISSING_USR_ROL) if user_role.nil?
        user = user_role.user
        user_role.destroy
        resp_ok
      end

##### organization

      desc "add user organization role (user type)"
      params do
        requires 'user_id', type: Integer, desc: "user_id"
        requires 'organization_id', type: Integer, desc: "organization id"
        requires 'role_id', type: Integer, desc: "new user role id"
      end
      post :add_organization_role do
        authenticate!
        return resp_error(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(organization.organization)
        organization = Organization.find_by(id: params[:organization_id])
        return resp_error(MISSING_ORG) if organization.nil?
        user = User.find_by(id: params[:user_id])
        return resp_error(MISSING_USR) if user.nil?
        role = Role.find_by(id: params[:role_id], role_type: 'organization')
        return resp_error(MISSING_ROL) if role.nil?
        user_organization = organization.user_organizations.find_or_create_by(user: user, role_id: role.id)
        resp_ok("user_organization" => UserOrganizationSerializer.new(user_organization))
      end

      desc "change user organization role (user type)"
      params do
        requires 'user_organization_id', type: Integer, desc: "user_organizations id"
        requires 'role_id', type: Integer, desc: "new user role id"
      end
      post :change_organization_role do
        authenticate!
        return resp_error(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(organization.organization)
        user_organization = UserOrganization.find_by(id: params[:user_organization_id])
        return resp_error(MISSING_USR_ORG) if user_organization.nil?
        role = Role.find_by(id: params[:role_id], role_type: 'organization')
        return resp_error(MISSING_ROL) if role.nil?
        user_organization.update_attributes(role_id: role.id)
        resp_ok("user_organization" => UserOrganizationSerializer.new(user_organization))
      end

      desc "delete user organization role (user type)"
      params do
        requires 'user_organization_id', type: Integer, desc: "user_organizations id"
      end
      post :delete_organization_role do
        authenticate!
        return resp_error(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(organization.organization)
        user_organization = UserOrganization.find_by(id: params[:user_organization_id])
        return resp_error(MISSING_USR_ORG) if user_organization.nil?
        user = user_organization.user
        user_organization.destroy
        resp_ok
      end

##### invention

      desc "add user invention role (user type)"
      params do
        requires 'user_id', type: Integer, desc: "user_id"
        requires 'invention_id', type: Integer, desc: "invention id"
        requires 'role_id', type: Integer, desc: "new user role id"
      end
      post :add_invention_role do
        authenticate!
        return resp_error(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(invention.invention)
        invention = Invention.find_by(id: params[:invention_id])
        return resp_error(MISSING_INV) if invention.nil?
        user = User.find_by(id: params[:user_id])
        return resp_error(MISSING_USR) if user.nil?
        role = Role.find_by(id: params[:role_id], role_type: 'invention')
        return resp_error(MISSING_ROL) if role.nil?
        user_invention = invention.user_inventions.find_or_create_by(user: user, role_id: role.id)
        resp_ok("user_invention" => UserInventionSerializer.new(user_invention))
      end

      desc "change user invention role (user type)"
      params do
        requires 'user_invention_id', type: Integer, desc: "user_inventions id"
        requires 'role_id', type: Integer, desc: "new user role id"
      end
      post :change_invention_role do
        authenticate!
        return resp_error(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(invention.invention)
        user_invention = UserInvention.find_by(id: params[:user_invention_id])
        return resp_error(MISSING_USR_ORG) if user_invention.nil?
        role = Role.find_by(id: params[:role_id], role_type: 'invention')
        return resp_error(MISSING_ROL) if role.nil?
        user_invention.update_attributes(role_id: role.id)
        resp_ok("user_invention" => UserInventionSerializer.new(user_invention))
      end

      desc "delete user invention role (user type)"
      params do
        requires 'user_invention_id', type: Integer, desc: "user_inventions id"
      end
      post :delete_invention_role do
        authenticate!
        return resp_error(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(invention.invention)
        user_invention = UserInvention.find_by(id: params[:user_invention_id])
        return resp_error(MISSING_USR_ORG) if user_invention.nil?
        user = user_invention.user
        user_invention.destroy
        resp_ok
      end

#### get role

      desc "user organization roles"
      params do
        requires 'organization_id', type: Integer, desc: "organization id"
        requires 'user_id', type: Integer, desc: "user_id"
      end
      get :organization_roles do
        authenticate!
        organization = Organization.find_by(id: params[:organization_id])
        return resp_error(MISSING_ORG) if organization.nil?
        user = organization.users.find_by(id: params[:user_id])
        return resp_error(MISSING_ORG_USR) if user.nil?
        organization_roles = user.organization_roles(organization)
        resp_ok("organization_roles" => RoleSerializer.build_array(organization_roles))
      end

      desc "user invention roles"
      params do
        requires 'invention_id', type: Integer, desc: "invention id"
        requires 'user_id', type: Integer, desc: "user_id"
      end
      get :invention_roles do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return resp_error(MISSING_INV) if invention.nil?
        user = invention.users.find_by(id: params[:user_id])
        return resp_error(MISSING_INV_USR) if user.nil?
        invention_roles = user.invention_roles(invention)
        resp_ok("invention_roles" => RoleSerializer.build_array(invention_roles))
      end

      desc "user global roles"
      params do
        requires 'user_id', type: Integer, desc: "user_id"
      end
      get :global_roles do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return resp_error(MISSING_USR) if user.nil?
        resp_ok("global_roles" => RoleSerializer.build_array(user.roles))
      end

    end
  end
end
