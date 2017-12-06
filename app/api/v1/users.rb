module V1
  class Users < Grape::API
    version 'v1'
    format :json

    resource :users do

      desc "sign up by email"
      params do
        requires :email, type: String, desc: "email"
      end
      post :sign_up do
        return resp_error('Bad email format.') if params[:email] !~ //
        user = User.find_by(email: params[:email].downcase)
        return resp_error('This email has been registered.') if user.present?
        user = User.create!(
          email: params[:email].downcase,
          password: SecureRandom.base58
        )
        resp_ok("user" => UserSerializer.new(user))
      end

      desc "login by magic link"
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

      desc "logout"
      params do
      end
      post :login_out do
        authenticate!
        begin
          current_user.auth.reset_secure_random
          current_user.update_access_token
          return resp_ok("sign out sccessful.")
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
        requires 'user', type: Hash do
          optional 'first_name', type: String, desc: "first_name"
          optional 'last_name', type: String, desc: "last_name"
          optional 'screen_name', type: String, desc: "screen_name"
          optional 'employer', type: String, desc: "employer"
          optional 'time_zone', type: String, desc: "time_zone"
          optional 'personal_summary', type: String, desc: "personal_summary"
        end
        optional 'citizenships', type: Array, desc: "citizenships"
        optional 'languages', type: Array, desc: "languages"
        optional 'addresses', type: Hash do
          optional 'address_type', type: String, desc: "address_type(home, work)"
          optional 'street_address', type: String, desc: "street_address"
          optional 'city', type: String, desc: "city"
          optional 'state_province', type: String, desc: "state_province"
          optional 'country', type: String, desc: "country"
          optional 'postal_code', type: String, desc: "postal_code"
          optional 'phone_type', type: String, desc: "phone_type(mobile,home)"
          optional 'phone', type: String, desc: "phone"
        end
      end
      get :update do
        authenticate!
        binding.pry
        resp_ok("user" => UserSerializer.new(current_user))
      end

      desc "delete user"
      params do
      end
      get :delete do
        authenticate!
        resp_ok("user" => UserSerializer.new(current_user))
      end

    end
  end
end
