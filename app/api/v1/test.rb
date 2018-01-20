module V1
  class Test < Grape::API
    version 'v1'
    format :json

    resource :test do

      desc "sign up by email / create user"
      params do
        requires :email, type: String, desc: "email"
      end
      post :sign_up do
        return unauthorized('Bad email format.') if params[:email] !~ /^([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+$/i
        user = User.find_by(email: params[:email].downcase)
        return unauthorized('This email has been registered.') if user.present?
        user = User.create!(
          email: params[:email].downcase,
          password: SecureRandom.base58
        )
        Mailer.magic_link_email(user, 'Successfully Signed Up.').deliver
        resp_ok("user" => UserSerializer.new(user))
      end

      desc "login by magic link / get user access token"
      params do
        requires :magic_link, type: String, desc: "magic_link"
      end
      post :login do
        auth = Auth.find_by_secure_random(params[:magic_link])
        return unauthorized("Expired magic link") if auth.nil?
        user = auth.user
        user.update_access_token
        resp_ok("user" => UserSerializer.new(user))
      end

      desc "get user"
      params do
        requires :user_id, type: Integer, desc: "user_id"
        end
      get :detail do
        user = User.find_by(id: params[:user_id])
        return data_not_found(MISSING_USR) if user.nil?
        resp_ok("user" => UserSerializer.new(user))
      end

      desc "get magic_link"
      params do
        optional :user_id, type: Integer, desc: "user_id"
        optional :email, type: String, desc: "email"
        at_least_one_of :user_id, :email
        end
      get :get_magic_link do
        user = User.find_by(id: params[:user_id]) if params[:user_id].present?
        user ||= User.find_by(email: params[:email]) if params[:email].present?
        return data_not_found(MISSING_USR) if user.nil?
        user.update_access_token
        user.auth.reset_secure_random
        resp_ok("user" => UserSerializer.new(user))
      end

      desc "update user"
      params do
        requires :user_id, type: Integer, desc: "user_id"
        optional 'user', type: Hash do
          optional 'firstname', type: String, desc: "first_name"
          optional 'lastname', type: String, desc: "last_name"
          optional 'screen_name', type: String, desc: "screen_name"
          optional 'employer', type: String, desc: "employer"
          optional 'time_zone', type: String, desc: "time_zone"
          optional 'personal_summary', type: String, desc: "personal_summary"
          optional 'resume', type: File, desc: "resume file"
        end
        optional 'citizenships', type: Array[Integer], coerce_with: ->(val) { val.split(/&/).map{|a| a.sub(/citizenships=/,'').to_i} }, desc: "citizenship ids in new lines"
        optional 'languages', type: Array[Integer], coerce_with: ->(val) { val.split(/&/).map{|a| a.sub(/languages=/,'').to_i} }, desc: "language ids in new lines"
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
        optional 'organizations', type: Array[Integer], coerce_with: ->(val) { val.split(/&/).map{|a| a.sub(/organizations=/,'').to_i} }, desc: "organization ids in new lines"
      end
      post :update do
        user = User.find_by(id: params[:user_id])
        return data_not_found(MISSING_USR) if user.nil?
        ActiveRecord::Base.transaction do
          if params[:user].present?
            permit_user_params = ActionController::Parameters.new(params[:user]).permit(
              :firstname, :lastname, :screen_name, :employer, :time_zone, :personal_summary
            )
            user.update(permit_user_params)
            user.update_resume(params[:user][:resume]) if params[:user][:resume].present?
          end

          if params[:citizenships].present?
            user.user_citizenships.where.not(citizenship_id: params[:citizenships]).map(&:destroy)
            params[:citizenships].each do |citizenship_id|
              user.user_citizenships.find_or_create_by(citizenship_id: citizenship_id)
            end
          end
          if params[:languages].present?
            user.user_languages.where.not(language_id: params[:languages]).map(&:destroy)
            params[:languages].each do |language_id|
              user.user_languages.find_or_create_by(language_id: language_id)
            end
          end
          if params[:organizations].present?
            user.user_organizations.where.not(organization_id: params[:organizations]).map(&:destroy)
            params[:organizations].each do |organization_id|
              user.user_organizations.find_or_create_by(organization_id: organization_id)
            end
          end
          params[:addresses].each do |address_params|
            permit_address_params = ActionController::Parameters.new(address_params).permit(
              :address_type, :street_address, :city, :state_province, :country, :postal_code
            ).merge(enable: true)
            if address_params[:address_id].present?
              address = user.addresses.find_by(id: address_params[:address_id])
              return data_not_found(MISSING_ADDRESS) if address.nil?
              address.update(permit_address_params)
              address_params[:phones].each do |phone_params|
                if phone_params[:phone_id].present?
                  phone = address.phones.find_by(id: phone_params[:phone_id])
                  return data_not_found(MISSING_PHONE) if phone.nil?
                  permit_phone_params = ActionController::Parameters.new(phone_params).permit(
                    :phone_type, :phone_number
                  ).merge(enable: true)
                  phone.update(permit_phone_params)
                else
                  phone = address.phones.create(phone_params)
                end
              end if address_params[:phones].present?
            else
              address = user.addresses.create(permit_address_params)
              address_params[:phones].each do |phone_params|
                permit_phone_params = ActionController::Parameters.new(phone_params).permit(
                  :phone_type, :phone_number
                ).merge(enable: true)
                phone = address.phones.create(permit_phone_params)
              end if address_params[:phones].present?
            end
          end if params[:addresses].present?
        end
        resp_ok("user" => UserSerializer.new(user))
      end

    end
  end
end
