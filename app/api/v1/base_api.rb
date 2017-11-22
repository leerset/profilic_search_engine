module V1
  class BaseApi < API
    version 'v1', using: :path

    mount V1::Users

    add_swagger_documentation(
      api_version: 'api/v1',
      hide_documentation_path: true,
      hide_format: true
    )
  end
end
