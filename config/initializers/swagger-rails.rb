GrapeSwaggerRails.options.url = "/api/v1/swagger_doc"
GrapeSwaggerRails.options.app_url  = '/'
GrapeSwaggerRails.options.before_action do
  authenticate_user!
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
end
