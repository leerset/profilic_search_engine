module V1
  class Users < Grape::API
    version 'v1'
    format :json

    resource :users do

      desc "PEOPLE add"
      params do
        requires 'first_name', type: String, desc: "first_name"
        requires 'last_name', type: String, desc: "last_name"
        requires 'email', type: String, desc: "email"
        requires 'organization', type: String, desc: "organization"
      end
      get :add do
        return resp_error('Bad email format') if params[:email] !~ /^([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+$/i
        user = User.find_by(email: params[:email].downcase)
        return resp_error("PEOPLE exist with email: #{params[:email]}") if user.present?
        ActiveRecord::Base.transaction do
          user = User.create!(
            email: params[:email].downcase,
            password: SecureRandom.base58
          )
          organization = Organization.find_or_create_by(name: params[:organization])
          user.update(
            firstname: params[:first_name],
            lastname: params[:last_name]
          )
          user.user_organizations.find_or_create_by(organization: organization)
          resp_ok("user" => UserSerializer.new(user))
        end
      end

      desc "SGIN IN"
      params do
        requires 'email', type: String, desc: "email"
        requires 'password', type: String, desc: "password"
      end
      get :sign_in do
        user = User.find_by(email: params[:email].downcase)
        return resp_error('bad email / password') if user.nil?
        if user.valid_password?(params[:password])
          user.update(
            current_sign_in_at: Time.now,
            current_sign_in_ip: request.env['REMOTE_ADDR'],
            sign_in_count: user.sign_in_count + 1
          )
          return resp_ok("user" => UserSerializer.new(user))
        else
          return resp_error('bad email / password')
        end
      end

      desc "CREATE ACCOUNT"
      params do
        requires :name, type: String, desc: "name"
        requires :email, type: String, desc: "email"
        requires :password, type: String, desc: "password"
        requires :confirm_password, type: String, desc: "confirm_password"
      end
      post :create_account do
        return resp_error('Bad email format.') if params[:email] !~ /^([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+$/i
        return resp_error('different passwords') if params[:password] != params[:confirm_password]
        user = User.find_by(email: params[:email].downcase)
        return resp_error('This email has been registered.') if user.present?
        user = User.create!(
          email: params[:email].downcase,
          password: SecureRandom.base58
        )
        user.update(
          password: params[:password],
          screen_name: params[:name]
        )
        resp_ok("user" => UserSerializer.new(user))
      end

      desc "sign up by email / create user"
      params do
        requires :email, type: String, desc: "email"
      end
      post :sign_up do
        return resp_error('Bad email format.') if params[:email] !~ /^([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+$/i
        user = User.find_by(email: params[:email].downcase)
        return resp_error('This email has been registered.') if user.present?
        user = User.create!(
          email: params[:email].downcase,
          password: SecureRandom.base58
        )
        resp_ok("user" => UserSerializer.new(user))
      end

      desc "login by magic link / get user access token"
      params do
        requires :magic_link, type: String, desc: "magic_link"
      end
      post :login do
        auth = Auth.find_by_secure_random(params[:magic_link])
        return resp_error("Expired magic link") if auth.nil?
        user = auth.user
        user.update_access_token
        resp_ok("user" => UserSerializer.new(user))
      end

      desc "logout / reset magic link and access token"
      params do
      end
      post :logout do
        authenticate!
        begin
          current_user.auth.reset_secure_random
          current_user.update_access_token
          return resp_ok("logout sccessful.")
        rescue => err
          Rails.logger.debug err.to_s
          return service_unavailable
        end
      end

      desc "get user"
      params do
      end
      get :detail do
        authenticate!
        resp_ok("user" => UserSerializer.new(current_user))
      end

      desc "update user"
      params do
        optional 'user', type: Hash do
          optional 'firstname', type: String, desc: "first_name"
          optional 'lastname', type: String, desc: "last_name"
          optional 'screen_name', type: String, desc: "screen_name"
          optional 'employer', type: String, desc: "employer"
          optional 'time_zone', type: String, desc: "time_zone"
          optional 'personal_summary', type: String, desc: "personal_summary"
          optional 'resume', type: File, desc: "resume file"
        end
        optional 'citizenships', type: Array[Integer], desc: "citizenship ids"
        optional 'languages', type: Array[Integer], desc: "language ids"
        optional 'addresses', type: Array do
          optional 'address_id', type: Integer, desc: "address_id (optional, id = null will create a new record)"
          optional 'address_type', type: String, desc: "address_type (home, work, etc.)"
          optional 'street_address', type: String, desc: "street_address"
          optional 'city', type: String, desc: "city"
          optional 'state_province', type: String, desc: "state_province"
          optional 'country', type: String, desc: "country"
          optional 'postal_code', type: String, desc: "postal_code"
          optional 'phones', type: Array do
            optional 'phone_id', type: Integer, desc: "phone_id (optional, id = null will create a new record)"
            optional 'phone_type', type: String, desc: "phone_type (mobile, home, etc.)"
            optional 'phone_number', type: String, desc: "phone_number"
          end
        end
        optional 'organizations', type: Array[Integer], desc: "organization ids"
      end
      post :update do
        authenticate!
        ActiveRecord::Base.transaction do
          if params[:user].present?
            permit_user_params = ActionController::Parameters.new(params[:user]).permit(
              :firstname, :lastname, :screen_name, :employer, :time_zone, :personal_summary
            )
            current_user.update(permit_user_params)
          end

          if params[:citizenships].present?
            current_user.user_citizenships.where.not(citizenship_id: params[:citizenships]).map(&:destroy)
            params[:citizenships].each do |citizenship_id|
              current_user.user_citizenships.find_or_create_by(citizenship_id: citizenship_id)
            end
          end
          if params[:languages].present?
            current_user.user_languages.where.not(language_id: params[:languages]).map(&:destroy)
            params[:languages].each do |language_id|
              current_user.user_languages.find_or_create_by(language_id: language_id)
            end
          end
          if params[:organizations].present?
            current_user.user_organizations.where.not(organization_id: params[:organizations]).map(&:destroy)
            params[:organizations].each do |organization_id|
              current_user.user_organizations.find_or_create_by(organization_id: organization_id)
            end
          end
          params[:addresses].each do |address_params|
            permit_address_params = ActionController::Parameters.new(address_params).permit(
              :address_type, :street_address, :city, :state_province, :country, :postal_code
            ).merge(enable: true)
            if address_params[:address_id].present?
              address = current_user.addresses.find_by(id: address_params[:address_id])
              return resp_error("no address found") if address.nil?
              address.update(permit_address_params)
              address_params[:phones].each do |phone_params|
                if phone_params[:phone_id].present?
                  phone = address.phones.find_by(id: phone_params[:phone_id])
                  return resp_error("no phone found") if phone.nil?
                  permit_phone_params = ActionController::Parameters.new(phone_params).permit(
                    :phone_type, :phone_number
                  ).merge(enable: true)
                  phone.update(permit_phone_params)
                else
                  phone = address.phones.create(phone_params)
                end
              end if address_params[:phones].present?
            else
              address = current_user.addresses.create(permit_address_params)
              address_params[:phones].each do |phone_params|
                permit_phone_params = ActionController::Parameters.new(phone_params).permit(
                  :phone_type, :phone_number
                ).merge(enable: true)
                phone = address.phones.create(permit_phone_params)
              end if address_params[:phones].present?
            end
          end if params[:addresses].present?
        end
        resp_ok("user" => UserSerializer.new(current_user))
      end

      # desc "delete user"
      # params do
      # end
      # get :delete do
      #   authenticate!
      #   current_user.destroy
      #   resp_ok("deleted")
      # end

    end
  end
end
