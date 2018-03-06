module V1
  class BaseApi < Grape::API
    prefix 'API'
    version 'v1', using: :path

    mount V1::Concepts
    mount V1::Options
    mount V1::Organizations
    mount V1::Users
    mount V1::Test
    mount V1::Inventions
    mount V1::UserRoles
    mount V1::TestRoles
    mount V1::People
    mount V1::InventionOpportunities
    mount V1::UploadFiles

    add_swagger_documentation(
      api_version: 'API/v1',
      hide_documentation_path: true,
      hide_format: false
    )
  end
end
