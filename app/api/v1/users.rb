module V1
  class Users < Grape::API
    version 'v1'
    format :json

    resource :users do

      desc "get user"
      params do
      end
      get :detail do
        authenticate!
        resp_ok("user" => UserSerializer.new(current_user).serializable_hash.merge(access_token: current_user.access_token))
      end

      desc "sign up by email"
      params do
        requires :email, type: String, desc: "email"
      end
      post :sign_up do
        return resp_error('Bad email format.') if params[:email] !~ //
        user = User.find_by(email: params[:email].downcase)
        return resp_error('This email has been registered.') if user.present?
        user = User.create(
          email: params[:email].downcase,
          password: SecureRandom.base58
        )
        resp_ok("user" => UserSerializer.new(user).serializable_hash.merge(access_token: user.access_token))
      end

      desc "login in by magic link"
      params do
        requires :magic_link, type: String, desc: "magic_link"
      end
      post :login_in do
        auth = Auth.find_by_secure_random(params[:magic_link])
        return resp_error("Expired magic link") if auth.nil?
        user = auth.user
        user.generate_access_token
        resp_ok("user" => UserSerializer.new(user).serializable_hash.merge(access_token: user.access_token))
      end

      desc "sign out"
      params do
      end
      post :sign_out do
        authenticate!
        begin
          current_user.auth.reset_secure_random
          current_user.generate_access_token
          return resp_ok("sign out sccessful.")
        rescue => err
          Rails.logger.debug err.to_s
          return service_unavailable
        end
      end

    end
  end
end
