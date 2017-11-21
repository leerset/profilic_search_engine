class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @magic_link = ["http://", request.host_with_port, "/auth/", current_user.auth.secure_random].join
  end
end
