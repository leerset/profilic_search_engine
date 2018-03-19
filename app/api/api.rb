require "grape-swagger"

class API < Grape::API
  prefix 'API'
  formatter :json, Grape::Formatter::ActiveModelSerializers

  # before do
  #   set_locale
  # end

  helpers do
    def set_locale
      locale = request.headers['Locale']
      locale ||= current_user.try(:locale) if defined?(current_user)
      locale ||= I18n.default_locale
      I18n.locale = locale
    end

    def authenticate!
      Rails.logger.debug request.headers['Authorization']
      unauthorized unless current_user
    end

    def current_user
      # return User.first if request.headers["Host"] == 'localhost:3000'
      return nil unless request.headers['Authorization'].present?
      user = User.includes(:user_organization_statuses).where(access_token: request.headers['Authorization']).first
      # error!(unauthorized('You have not signed in for a long time, please login again.'), 401) if user && user.expired?
      unauthorized('You have not signed in for a long time, please login again.') if user && user.expired?
      unauthorized('Suspended prolific status, should not be allowed to sign in.') if user && user.prolific_status && user.prolific_status.downcase == 'suspended'
      unauthorized('Deleted prolific status, should not be allowed to sign in.') if user && user.prolific_status && user.prolific_status.downcase == 'deleted'
      return user
    end

    # return data, or return data={} means found_no_data
    def resp_ok(data = {}, message: '')
      {code: 200, data: data, message: message}
    end

    # frontend only displays the messages
    def resp_error(message = '')
      # {code: 300, message: message}
      error!({code: 300, message: message}, 300)
    end

    # bad_request 400
    def bad_request(message = '')
      # {code: 300, message: message}
      error!({code: 400, message: message, error: message}, 400)
    end

    # conflict 409
    def data_exist(message = '')
      # {code: 300, message: message}
      error!({code: 409, message: message}, 409)
    end

    # forbidden 403
    def permission_denied(message = '')
      # {code: 300, message: message}
      error!({code: 403, message: message}, 403)
    end

    # do not use
    def data_not_found(message = '')
      # {code: 404, message: message}
      error!({code: 404, message: message}, 404)
    end

    # frontend turns to login page.
    def unauthorized(message = 'You are unauthorized to perform that operation')
      # {code: 401, message: message}
      error!({code: 401, message: message}, 401)
    end

    def service_unavailable(message = 'Service Error，please try again later.')
      # {code: 503, message: message}
      error!({code: 503, message: message}, 503)
    end

  end

  mount V1::BaseApi
end
