class AuthsController < ApplicationController
  before_action :set_auth, only: [:show]
  # include Devise::Controllers::SignInOut

  def index
  end

  def show
    if @auth.present?
      @auth.reset_secure_random
      sign_in(@user)
    else
      redirect_to "/users/sign_up"
    end
  end

  def login_out
    sign_out(@user)
    redirect_to "/users/sign_up"
  end

  private

  def set_auth
    @auth = Auth.find_by_secure_random(params[:id])
    @user = @auth.try(:user)
  end

end
