module V1
  class ContainerSections < Grape::API
    version 'v1'
    format :json

    resource :container_sections do

      desc "create container_section"
      params do
        requires :invention_id, type: Integer, desc: "invention_id"
        optional :draw, type: String, desc: "draw content"
        optional :significance, type: String, desc: "significance content"
      end
      post :create do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return data_not_found(MISSING_INV) if invention.nil?
        unless current_user.inventor?(invention) || current_user.co_inventor?(invention)
          return permission_denied(NOT_CO_INVENTOR_DENIED)
        end
        invention.container_sections.create(draw: params[:draw], significance: params[:significance])
        resp_ok("invention" => InventionSerializer.new(invention))
      end

      desc "update container_section"
      params do
        requires :id, type: Integer, desc: "container_section id"
        optional :draw, type: String, desc: "draw content"
        optional :significance, type: String, desc: "significance content"
      end
      put :update do
        authenticate!
        container_section = ContainerSection.find_by(id: params[:id])
        return data_not_found(MISSING_CS) if container_section.nil?
        invention = container_section.invention
        unless current_user.inventor?(invention) || current_user.co_inventor?(invention)
          return permission_denied(NOT_CO_INVENTOR_DENIED)
        end
        container_section.update_attributes(draw: params[:draw], significance: params[:significance])
        resp_ok("invention" => InventionSerializer.new(invention))
      end

      desc "delete container_section"
      params do
        requires :id, type: Integer, desc: "container_section id"
      end
      delete :delete do
        authenticate!
        container_section = ContainerSection.find_by(id: params[:id])
        return data_not_found(MISSING_CS) if container_section.nil?
        invention = container_section.invention
        unless current_user.inventor?(invention) || current_user.co_inventor?(invention)
          return permission_denied(NOT_CO_INVENTOR_DENIED)
        end
        container_section.destroy
        resp_ok("invention" => InventionSerializer.new(invention))
      end

    end
  end
end
