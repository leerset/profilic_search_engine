module V1
  class UserOrganizations < Grape::API
    version 'v1'
    format :json

    resource :user_organizations do

##### organization status

      desc "get user organization status"
      params do
        requires 'user_id', type: Integer, desc: "user_id"
      end
      get :organization_statuses do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return data_not_found(MISSING_USR) if user.nil?
        resp_ok('user_organization_statuses' =>
          UserOrganizationStatusSerializer.build_array(user.user_organization_statuses))
      end

      desc "change user organization status"
      params do
        requires 'user_id', type: Integer, desc: "user_id"
        requires 'organization_id', type: Integer, desc: "organization id"
        requires 'status', type: String, values: ['Active', 'Inactive', 'Suspended', 'Deleted'], desc: "status"
        optional 'title', type: String, desc: "title"
        optional 'phone', type: String, desc: "phone"
      end
      put :change_organization_status do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return data_not_found(MISSING_USR) if user.nil?
        organization = Organization.find_by(id: params[:organization_id])
        return data_not_found(MISSING_ORG) if organization.nil?
        return permission_denied(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(organization)
        user_organization_status = user.user_organization_statuses.find_or_create_by(organization_id: organization.id)
        user_organization_status.update(
          status: params[:status],
          title: params[:title],
          phone: params[:phone]
        )
        resp_ok('user_organization_statuses' =>
          UserOrganizationStatusSerializer.build_array(user.user_organization_statuses))
      end

      desc "delete user from organization"
      params do
        requires 'user_id', type: Integer, desc: "user_id"
        requires 'organization_id', type: Integer, desc: "organization id"
      end
      delete :delete do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return data_not_found(MISSING_USR) if user.nil?
        organization = Organization.find_by(id: params[:organization_id])
        return data_not_found(MISSING_ORG) if organization.nil?
        return permission_denied(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(organization)
        user_organization_status = user.user_organization_statuses.find_or_create_by(organization_id: organization.id)
        user_organization_status.update(
          status: 'Deleted'
        )
        user.user_organizations.where(organization: organization).destroy_all
        resp_ok('user_organization_statuses' =>
          UserOrganizationStatusSerializer.build_array(user.user_organization_statuses))
      end

    end
  end
end
