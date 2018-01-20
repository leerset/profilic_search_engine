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
        return data_not_found(MISSING_CONCEPT) if concept.nil?
        resp_ok("concept" => ConceptSerializer.new(concept))
      end

      desc "concept versions"
      params do
        requires :id, type: Integer, desc: "concept id"
      end
      get :versions do
        authenticate!
        concept = Concept.find_by(id: params[:id])
        return data_not_found(MISSING_CONCEPT) if concept.nil?
        resp_ok("versions" => ConceptSerializer.build_array(concept.versions.map(&:reify).compact))
      end

      desc "update concept"
      params do
        requires :id, type: Integer, desc: "concept id"
        requires :summary, type: String, desc: "summary"
      end
      put :update do
        authenticate!
        concept = Concept.find_by(id: params[:id])
        return data_not_found(MISSING_CONCEPT) if concept.nil?
        concept.paper_trail.whodunnit(current_user.email) do
          concept.update_attributes(summary: params[:summary])
        end
        resp_ok("concept" => ConceptSerializer.new(concept))
      end

      desc "create concept"
      params do
        requires :summary, type: String, desc: "summary"
      end
      post :create do
        authenticate!
        concept = current_user.concepts.create(summary: params[:summary])
        return data_not_found(MISSING_CONCEPT) if concept.nil?
        resp_ok("concept" => ConceptSerializer.new(concept))
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
        return data_not_found(MISSING_CONCEPT) if concepts.empty?
        resp_ok("concepts" => ConceptSimpleSerializer.build_array(concepts))
      end

    end
  end
end
