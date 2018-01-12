module V1
  class UserRoles < Grape::API
    version 'v1'
    format :json

    resource :user_roles do

#### global

      desc "get user global roles"
      params do
        requires 'user_id', type: Integer, desc: "user_id"
      end
      get :get_global_roles do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return resp_error(MISSING_USR) if user.nil?
        resp_ok("global_roles" => user.global_roles_array)
      end

      desc "set user global roles"
      params do
        requires 'user_id', type: Integer, desc: "user_role id"
        requires 'role_ids', type: Array[Integer], desc: "new user role ids"
      end
      put :set_global_roles do
        authenticate!
        return resp_error(NOT_GOD_DENIED) unless current_user.god?
        user = User.find_by(id: params[:user_id])
        return resp_error(MISSING_USR) if user.nil?
        role_ids = params[:role_ids].uniq
        return resp_error(MISSING_ROL) if Role.where(role_type: 'global', id: role_ids).count < role_ids.count
        user.user_roles.where.not(role_id: role_ids).destroy_all
        role_ids.each do |role_id|
          user.user_roles.find_or_create_by(role_id: role_id)
        end
        resp_ok("global_roles" => user.global_roles_array)
      end

##### organization OA

      desc "make user OA"
      params do
        requires 'user_id', type: Integer, desc: "user_id"
        requires 'organization_id', type: Integer, desc: "organization id"
      end
      put :make_oa do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return resp_error(MISSING_USR) if user.nil?
        organization = Organization.find_by(id: params[:organization_id])
        return resp_error(MISSING_ORG) if organization.nil?
        return resp_error(NOT_GOD_DENIED) unless current_user.god?
        role = Role.find_by(code: 'organization_administrator')
        user.user_organizations.find_or_create_by(organization_id: organization.id, role_id: role.id)
        resp_ok('organization_roles' => user.organization_roles_array)
      end

      desc "remove user OA"
      params do
        requires 'user_id', type: Integer, desc: "user_id"
        requires 'organization_id', type: Integer, desc: "organization id"
      end
      delete :remove_oa do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return resp_error(MISSING_USR) if user.nil?
        organization = Organization.find_by(id: params[:organization_id])
        return resp_error(MISSING_ORG) if organization.nil?
        return resp_error(NOT_GOD_DENIED) unless current_user.god?
        role = Role.find_by(code: 'organization_administrator')
        return resp_error(MISSING_ROL) if role.nil?
        user_organization = user.user_organizations.find_by(organization_id: organization.id, role_id: role.id)
        user_organization.destroy if user_organization.present?
        resp_ok('organization_roles' => user.organization_roles_array)
      end

##### one organization join

      desc "assign user to another organization"
      params do
        requires 'user_id', type: Integer, desc: "user_id"
        requires 'organization_id', type: Integer, desc: "organization id"
      end
      post :join_organization do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return resp_error(MISSING_USR) if user.nil?
        organization = Organization.find_by(id: params[:organization_id])
        return resp_error(MISSING_ORG) if organization.nil?
        return resp_error(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(organization)
        role = Role.find_by(code: 'organization_member')
        return resp_error(MISSING_ROL) if role.nil?
        user.user_organizations.find_or_create_by(organization_id: organization.id, role_id: role.id)
        user.user_organization_statuses.find_or_create_by(organization_id: organization.id).update(status: 'Active')
        resp_ok('organization_roles' => user.organization_roles_array)
      end

      desc "add user organization role"
      params do
        requires 'user_id', type: Integer, desc: "user_id"
        requires 'organization_id', type: Integer, desc: "organization id"
        requires 'role_id', type: Integer, desc: "new user role id"
      end
      post :add_organization_role do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return resp_error(MISSING_USR) if user.nil?
        organization = Organization.find_by(id: params[:organization_id])
        return resp_error(MISSING_ORG) if organization.nil?
        return resp_error(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(organization)
        role = Role.find_by(role_type: 'organization', id: params[:role_id])
        return resp_error(MISSING_ROL) if role.nil?
        user.user_organizations.find_or_create_by(organization_id: organization.id, role_id: role.id)
        resp_ok('organization_roles' => user.organization_roles_array)
      end

      desc "change user organization roles"
      params do
        requires 'user_id', type: Integer, desc: "user_id"
        requires 'organization_id', type: Integer, desc: "organization id"
        requires 'role_ids', type: Array[Integer], desc: "new user role ids"
      end
      put :change_organization_roles do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return resp_error(MISSING_USR) if user.nil?
        organization = Organization.find_by(id: params[:organization_id])
        return resp_error(MISSING_ORG) if organization.nil?
        return resp_error(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(organization)
        role_ids = params[:role_ids].uniq
        return resp_error(MISSING_ROL) if Role.where(role_type: 'organization', id: role_ids).count < role_ids.count
        user.user_organizations.where(organization: organization).where.not(role_id: role_ids).destroy_all
        role_ids.each do |role_id|
          user.user_organizations.find_or_create_by(organization_id: organization.id, role_id: role_id)
        end
        resp_ok('organization_roles' => user.organization_roles_array)
      end

      desc "delete user organization roles"
      params do
        requires 'user_id', type: Integer, desc: "user_id"
        requires 'organization_id', type: Integer, desc: "organization id"
      end
      delete :delete_organization_roles do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return resp_error(MISSING_USR) if user.nil?
        organization = Organization.find_by(id: params[:organization_id])
        return resp_error(MISSING_ORG) if organization.nil?
        return resp_error(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(organization)
        user.user_organizations.where(organization: organization).destroy_all
        resp_ok('organization_roles' => user.organization_roles_array)
      end

##### set / get organizations roles

      desc "get organizations roles"
      params do
        requires 'user_id', type: Integer, desc: "user_id"
      end
      get :get_organizations_roles do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return resp_error(MISSING_ORG_USR) if user.nil?
        resp_ok('organization_roles' => user.organization_roles_array)
      end

      desc "set organizations roles"
      params do
        requires 'user_id', type: Integer, desc: "user id"
        requires 'organization_roles', type: Array do
          requires 'organization_id', type: Integer, desc: "organization id"
          requires 'role_id', type: Integer, desc: "role id"
        end
      end
      put :set_organizations_roles do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return resp_error(MISSING_USR) if user.nil?
        organization_roles_params = params[:organization_roles]
        organization_ids = organization_roles_params.map{|a| a[:organization_id].to_i}.uniq
        return resp_error(MISSING_ORG) if Organization.find_by(id: organization_id).count < organization_ids.count
        role_ids = organization_roles_params.map{|a| a[:role_id].to_i}.uniq
        return resp_error(MISSING_ROL) if Role.where(role_type: 'organization', id: role_ids).count < role_ids.count
        organizations = Organization.where(id: (organization_ids + user.organizations.map(&:id)).uniq)
        return resp_error(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.all_oa?(organizations)
        organization_ids.each do |organization_id|
          role_ids = organization_roles_params.select{|a| a[:organization_id].to_i == organization_id}.map{|a| a[:role_id]}
          user.user_organizations.where(organization_id: organization_id).where.not(role_id: role_ids).destroy_all
          role_ids.each do |role_id|
            user.user_organizations.find_or_create_by(organization_id: organization_id, role_id: role_id)
          end
        end
        resp_ok('organization_roles' => user.organization_roles_array)
      end

##### invention

    end
  end
end
