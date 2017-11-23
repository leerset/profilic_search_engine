module V1
  class Concepts < Grape::API
    version 'v1'
    format :json

    resource :concepts do

      desc "get concept"
      params do
        requires :id, type: Integer, desc: "concept id"
      end
      get :detail do
        authenticate!
        concept = Concept.find_by(id: params[:id])
        return resp_error('no concept found.') if concept.nil?
        resp_ok("concept" => ConceptDetailSerializer.new(concept))
      end

      desc "query concept"
      params do
        requires :query_content, type: String, desc: "concept query content"
      end
      get :list do
        authenticate!
        search = Concept.search do
          fulltext params[:query_content]
        end
        concepts = search.results
        return resp_error('no concept found.') if concepts.empty?
        resp_ok("concepts" => ConceptSerializer.build_array(concepts))
      end

    end
  end
end
