module V1
  class BaseApi < Grape::API
    prefix 'API'
    version 'v1', using: :path

    mount V1::Users

    add_swagger_documentation(
      api_version: 'API/v1',
      hide_documentation_path: true,
      hide_format: false
    )
  end
end
