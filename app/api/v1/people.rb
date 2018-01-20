module V1
  class People < Grape::API
    version 'v1'
    format :json

    resource :people do

      desc 'get people'
      params do
      end
      get :detail do
        authenticate!
        resp_ok(
          'user' => PeopleSerializer.new(current_user)
        )
      end

      desc 'get people'
      params do
        requires 'user_id', type: Integer, desc: "user id"
      end
      get :user do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return data_not_found(MISSING_USR) if user.nil?
        if current_user.god?
          resp_ok(
            'user' => PeopleSerializer.new(current_user)
          )
        else
          resp_ok(
            'user' => PeopleCommonSerializer.new(current_user)
          )
        end
      end

      desc 'update people'
      params do
        requires 'user_id', type: Integer, desc: "user id"
        optional 'user', type: Hash do
          optional 'firstname', type: String, desc: 'first_name'
          optional 'lastname', type: String, desc: 'last_name'
          optional 'email', type: String, desc: 'email'
          optional 'time_zone', type: String, desc: 'time_zone'
          optional 'citizenship', type: String, desc: 'citizenship'
          optional 'status', type: String, values: ['Active', 'Inactive', 'Suspended', 'Delete'], desc: "global status"
        end
        optional 'home_address', type: Hash do
          optional 'street1', type: String, desc: 'street1'
          optional 'street2', type: String, desc: 'street2'
          optional 'city', type: String, desc: 'city'
          optional 'state_province', type: String, desc: 'state_province'
          optional 'country', type: String, desc: 'country'
          optional 'postal_code', type: String, desc: 'postal_code'
        end
        optional 'work_address', type: Hash do
          optional 'employer', type: String, desc: 'employer'
          optional 'street1', type: String, desc: 'street1'
          optional 'street2', type: String, desc: 'street2'
          optional 'city', type: String, desc: 'city'
          optional 'state_province', type: String, desc: 'state_province'
          optional 'country', type: String, desc: 'country'
          optional 'postal_code', type: String, desc: 'postal_code'
        end
      end
      put :update do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return data_not_found(MISSING_USR) if user.nil?
        return permission_denied(NOT_GOD_DENIED) unless current_user.god?
        ActiveRecord::Base.transaction do
          if params[:user].present?
            permit_user_params = ActionController::Parameters.new(params[:user]).permit(
              :firstname, :lastname, :email, :time_zone, :citizenship, :status)
            user.update(permit_user_params)
          end
          if params[:home_address].present?
            permit_address_params = ActionController::Parameters.new(params[:home_address]).permit(
              :employer, :street1, :street2, :city, :state_province, :country, :postal_code
            ).merge(enable: true)
            user.update_home_address(permit_address_params)
          end
          if params[:work_address].present?
            permit_address_params = ActionController::Parameters.new(params[:work_address]).permit(
              :employer, :street1, :street2, :city, :state_province, :country, :postal_code
            ).merge(enable: true)
            user.update_work_address(permit_address_params)
          end
        end
        resp_ok('user' => PeopleSerializer.new(user))
      end

##### global status

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

      desc "save user organization status"
      params do
        requires 'user_id', type: Integer, desc: "user_id"
        requires 'organization_id', type: Integer, desc: "organization id"
        requires 'status', type: String, values: ['Active', 'Inactive', 'Suspended', 'Delete'], desc: "status"
        optional 'title', type: String, desc: "title"
        optional 'phone', type: String, desc: "phone"
      end
      put :save_organization_status do
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

    end
  end
end
