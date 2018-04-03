module V1
  class Organizations < Grape::API
    version 'v1'
    format :json

    resource :organizations do

      desc "get the corresponding possible opportunities in organization"
      params do
        requires :organization_id, type: Integer, desc: 'organization id'
        optional :opportunity_status, default: 'Active', type: String, desc: 'opportunities status: Active, Inactive'
        optional :inventor_status, default: 'Active', type: String, desc: 'inventors status: Active, Inactive'
      end
      get :opportunities_and_inventors do
        authenticate!
        organization = Organization.find_by(id: params[:organization_id])
        return data_not_found(MISSING_ORG) if organization.nil?
        invention_opportunities = if (opportunity_status = params[:opportunity_status]).present?
          organization.invention_opportunities.where(status: opportunity_status).order(created_at: :desc)
        else
          organization.invention_opportunities.order(status: :asc, created_at: :desc)
        end
        uos = if (inventor_status = params[:inventor_status]).present?
          organization.user_organization_statuses.includes(:user).where(status: inventor_status).order(created_at: :desc)
        else
          organization.user_organization_statuses.includes(:user).order(status: :asc, created_at: :desc)
        end
        resp_ok(
          "inventors" => UserSerializer.build_array(uos.map(&:user).uniq),
          "invention_opportunities" => InventionOpportunitySerializer.build_array(invention_opportunities)
        )
      end

      desc "get the corresponding possible opportunities in organization"
      params do
        requires :organization_id, type: Integer, desc: 'organization id'
        optional :status, default: 'Active', type: String, desc: 'opportunities status: Active, Inactive'
      end
      get :opportunities do
        authenticate!
        organization = Organization.find_by(id: params[:organization_id])
        return data_not_found(MISSING_ORG) if organization.nil?
        invention_opportunities = if (status = params[:status]).present?
          organization.invention_opportunities.where(status: status).order(created_at: :desc)
        else
          organization.invention_opportunities.order(status: :asc, created_at: :desc)
        end
        resp_ok("invention_opportunities" => InventionOpportunitySerializer.build_array(invention_opportunities))
      end

      desc "get the corresponding possible inventors in organization"
      params do
        requires :organization_id, type: Integer, desc: 'organization id'
        optional :status, default: 'Active', type: String, desc: 'opportunities status: Active, Inactive'
      end
      get :inventors do
        authenticate!
        organization = Organization.find_by(id: params[:organization_id])
        return data_not_found(MISSING_ORG) if organization.nil?
        uos = if (status = params[:status]).present?
          organization.user_organization_statuses.includes(:user).where(status: status).order(created_at: :desc)
        else
          organization.user_organization_statuses.includes(:user).order(status: :asc, created_at: :desc)
        end
        resp_ok("inventors" => UserSerializer.build_array(uos.map(&:user).uniq))
      end

      desc "get organization list GOD(get all) OA(get related) NUL(get empty array)"
      params do
      end
      get :list do
        authenticate!
        # return resp_error(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa_organizations.any?
        organizations = current_user.member_organizations
        resp_ok("organizations" => OrganizationSerializer.build_array(organizations))
      end

      # desc "get paged organization list"
      # params do
      #   optional :page, type: Integer, desc: 'curent page index，default: 1'
      #   optional :size, type: Integer, desc: 'records count in each page, default: 20'
      # end
      # get :paged_list do
      #   # authenticate!
      #   page = params[:page].presence || 1
      #   size = params[:size].presence || 20
      #   organizations = Organization.all.order(id: :desc).page(page).per(size)
      #   resp_ok("organizations" => OrganizationSerializer.build_array(organizations))
      # end

      desc "get organization"
      params do
        requires :organization_id, type: Integer, desc: 'organization id'
      end
      get :detail do
        authenticate!
        organization = Organization.find_by(id: params[:organization_id])
        return data_not_found(MISSING_ORG) if organization.nil?
        return permission_denied(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(organization)
        resp_ok("organization" => OrganizationSerializer.new(organization))
      end

      desc "delete organization"
      params do
        requires :organization_id, type: Integer, desc: 'organization id'
      end
      delete :delete do
        authenticate!
        organization = Organization.find_by(id: params[:organization_id])
        return data_not_found(MISSING_ORG) if organization.nil?
        return permission_denied(NOT_GOD_DENIED) unless current_user.god?
        organization.destroy!
        resp_ok(message: 'organization deleted')
      end

      desc "create organization"
      params do
        requires 'name', type: String, desc: "name"
        optional 'business_address', type: Hash do
          optional 'street1', type: String, desc: 'street1'
          optional 'street2', type: String, desc: 'street2'
          optional 'city', type: String, desc: 'city'
          optional 'state_province', type: String, desc: 'state_province'
          optional 'country', type: String, desc: 'country'
        end
      end
      post :create do
        authenticate!
        return permission_denied(NOT_GOD_DENIED) unless current_user.god?
        organization_name = params[:name].strip
        organization = Organization.find_by(name: organization_name)
        return data_exist(EXIST_ORG) if organization.present?
        new_organization = Organization.find_or_create_by(name: organization_name)
        if params[:business_address].present?
          permit_address_params = ActionController::Parameters.new(params[:business_address]).permit(
            :employer, :street1, :street2, :city, :state_province, :country
          ).merge(enable: true)
          new_organization.update_business_address(permit_address_params)
        end
        resp_ok("organization" => OrganizationSerializer.new(new_organization))
      end

      desc "update organization"
      params do
        requires :organization_id, type: Integer, desc: 'organization id'
        optional 'name', type: String, desc: "name"
        optional 'business_address', type: Hash do
          optional 'street1', type: String, desc: 'street1'
          optional 'street2', type: String, desc: 'street2'
          optional 'city', type: String, desc: 'city'
          optional 'state_province', type: String, desc: 'state_province'
          optional 'country', type: String, desc: 'country'
        end
      end
      put :update do
        authenticate!
        organization = Organization.find_by(id: params[:organization_id])
        return data_not_found(MISSING_ORG) if organization.nil?
        return permission_denied(NOT_GOD_OA_DENIED) unless current_user.god? || current_user.oa?(organization)
        organization.update_attributes(name: params[:name].strip) if params[:name].present?
        if params[:business_address].present?
          permit_address_params = ActionController::Parameters.new(params[:business_address]).permit(
            :employer, :street1, :street2, :city, :state_province, :country
          ).merge(enable: true)
          organization.update_business_address(permit_address_params)
        end
        resp_ok("organization" => OrganizationSerializer.new(organization))
      end

    end
  end
end
