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
        resp_ok('user' => PeopleSerializer.new(current_user, myself: true))
      end

      desc 'get people'
      params do
        requires 'user_id', type: Integer, desc: "user id"
      end
      get :user do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return data_not_found(MISSING_USR) if user.nil?
        orgs = (current_user.managed_organizations & user.organizations)
        return permission_denied(NOT_GOD_OA_DENIED) if !current_user.god? && orgs.empty?
        if current_user.god?
          resp_ok("user" => PeopleSerializer.new(user, god: true))
        elsif orgs.any?
          resp_ok("user" => PeopleSerializer.new(user, user_id: current_user.id, managed_organizations: orgs))
        else
          return permission_denied(NOT_GOD_OA_DENIED)
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
          optional 'status', type: String, values: ['Active', 'Inactive', 'Suspend', 'Delete'], desc: "global status"
        end
        optional 'home_address', type: Hash do
          optional 'street1', type: String, desc: 'street1'
          optional 'street2', type: String, desc: 'street2'
          optional 'city', type: String, desc: 'city'
          optional 'state_province', type: String, desc: 'state_province'
          optional 'country', type: String, desc: 'country'
          optional 'postal_code', type: String, desc: 'postal_code'
          optional 'phone_number', type: String, desc: 'phone_number'
        end
        optional 'work_address', type: Hash do
          optional 'employer', type: String, desc: 'employer'
          optional 'street1', type: String, desc: 'street1'
          optional 'street2', type: String, desc: 'street2'
          optional 'city', type: String, desc: 'city'
          optional 'state_province', type: String, desc: 'state_province'
          optional 'country', type: String, desc: 'country'
          optional 'postal_code', type: String, desc: 'postal_code'
          optional 'phone_number', type: String, desc: 'phone_number'
        end
      end
      put :update do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return data_not_found(MISSING_USR) if user.nil?
        orgs = (user.organizations & current_user.managed_organizations)
        return permission_denied(NOT_GOD_OA_DENIED) unless orgs.any? || current_user.god?
        ActiveRecord::Base.transaction do
          if params[:user].present?
            permit_attributes = [:firstname, :lastname, :email, :time_zone, :citizenship]
            permit_attributes << :status if current_user.god?
            permit_user_params = ActionController::Parameters.new(params[:user]).permit(permit_attributes)
            user.update(permit_user_params)
          end
          if params[:home_address].present?
            permit_address_params = ActionController::Parameters.new(params[:home_address]).permit(
              :employer, :street1, :street2, :city, :state_province, :country, :postal_code, :phone_number
            ).merge(enable: true)
            user.update_home_address(permit_address_params)
          end
          if params[:work_address].present?
            permit_address_params = ActionController::Parameters.new(params[:work_address]).permit(
              :employer, :street1, :street2, :city, :state_province, :country, :postal_code, :phone_number
            ).merge(enable: true)
            user.update_work_address(permit_address_params)
          end
        end
        resp_ok('user' => PeopleSerializer.new(user, user_id: current_user.id))
      end

      desc 'update people global status'
      params do
        requires 'user_id', type: Integer, desc: "user id"
        requires 'status', type: String, values: ['Active', 'Inactive', 'Suspend', 'Delete'], desc: "global status"
      end
      put :update_global_status do
        authenticate!
        user = User.find_by(id: params[:user_id])
        return data_not_found(MISSING_USR) if user.nil?
        return permission_denied(NOT_GOD_DENIED) unless current_user.god?
        user.update(status: params[:status])
        resp_ok('user' => PeopleSerializer.new(user, god: true))
      end

      desc 'update people himself'
      params do
        optional 'user', type: Hash do
          optional 'firstname', type: String, desc: 'first_name'
          optional 'lastname', type: String, desc: 'last_name'
          optional 'email', type: String, desc: 'email'
          optional 'time_zone', type: String, desc: 'time_zone'
          optional 'citizenship', type: String, desc: 'citizenship'
          # optional 'status', type: String, values: ['Active', 'Inactive', 'Suspend', 'Delete'], desc: "global status"
        end
        optional 'home_address', type: Hash do
          optional 'street1', type: String, desc: 'street1'
          optional 'street2', type: String, desc: 'street2'
          optional 'city', type: String, desc: 'city'
          optional 'state_province', type: String, desc: 'state_province'
          optional 'country', type: String, desc: 'country'
          optional 'postal_code', type: String, desc: 'postal_code'
          optional 'phone_number', type: String, desc: 'phone_number'
        end
        optional 'work_address', type: Hash do
          optional 'employer', type: String, desc: 'employer'
          optional 'street1', type: String, desc: 'street1'
          optional 'street2', type: String, desc: 'street2'
          optional 'city', type: String, desc: 'city'
          optional 'state_province', type: String, desc: 'state_province'
          optional 'country', type: String, desc: 'country'
          optional 'postal_code', type: String, desc: 'postal_code'
          optional 'phone_number', type: String, desc: 'phone_number'
        end
      end
      put :self_update do
        authenticate!
        user = current_user
        ActiveRecord::Base.transaction do
          if params[:user].present?
            permit_user_params = ActionController::Parameters.new(params[:user]).permit(
              :firstname, :lastname, :email, :time_zone, :citizenship)
            user.update(permit_user_params)
          end
          if params[:home_address].present?
            permit_address_params = ActionController::Parameters.new(params[:home_address]).permit(
              :employer, :street1, :street2, :city, :state_province, :country, :postal_code, :phone_number
            ).merge(enable: true)
            user.update_home_address(permit_address_params)
          end
          if params[:work_address].present?
            permit_address_params = ActionController::Parameters.new(params[:work_address]).permit(
              :employer, :street1, :street2, :city, :state_province, :country, :postal_code, :phone_number
            ).merge(enable: true)
            user.update_work_address(permit_address_params)
          end
        end
        resp_ok('user' => PeopleSerializer.new(user, myself: true))
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
        requires 'status', type: String, values: ['Active', 'Inactive', 'Suspend', 'Delete'], desc: "status"
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
