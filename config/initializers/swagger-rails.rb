GrapeSwaggerRails.options.url = "/API/v1/swagger_doc"
GrapeSwaggerRails.options.app_url  = '/'
GrapeSwaggerRails.options.before_action do
  # authenticate_user!
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
  GrapeSwaggerRails.options.api_key_name = "Authorization"
  GrapeSwaggerRails.options.api_key_type = "header"
end
