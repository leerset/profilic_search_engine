module V1
  class Options < Grape::API
    version 'v1'
    format :json

    resource :options do
      #
      # desc "get citizenships"
      # params do
      # end
      # get :citizenships do
      #   citizenships = Citizenship.all
      #   resp_ok("citizenships" => CitizenshipSerializer.build_array(citizenships))
      # end
      #
      # desc "get languages"
      # params do
      # end
      # get :languages do
      #   languages = Language.all
      #   resp_ok("languages" => LanguageSerializer.build_array(languages))
      # end
      #
      # desc "get time_zones"
      # params do
      # end
      # get :time_zones do
      #   time_zones = TimeZone.all
      #   resp_ok("time_zones" => TimeZoneSerializer.build_array(time_zones))
      # end

    end
  end
end
