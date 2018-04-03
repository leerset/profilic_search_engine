module V1
  class ContainerSections < Grape::API
    version 'v1'
    format :json

    resource :container_sections do

      # desc "create container_section"
      # params do
      #   requires :invention_id, type: Integer, desc: "invention_id"
      #   optional :draw, type: String, desc: "draw content"
      #   optional :significance, type: String, desc: "significance content"
      #   optional :landscape, type: String, desc: "landscape content"
      #   optional :problem_summary, type: String, desc: "problem_summary content"
      #   optional :gap, type: String, desc: "gap content"
      #   optional :problem_significance, type: String, desc: "problem_significance content"
      # end
      # post :create do
      #   authenticate!
      #   invention = Invention.find_by(id: params[:invention_id])
      #   return data_not_found(MISSING_INV) if invention.nil?
      #   unless current_user.inventor?(invention) || current_user.co_inventor?(invention)
      #     return permission_denied(NOT_CO_INVENTOR_DENIED)
      #   end
      #   permit_params = ActionController::Parameters.new(params).permit(
      #     :draw, :significance, :landscape, :problem_summary, :gap, :problem_significance
      #   )
      #   invention.create_container_section(permit_params)
      #   resp_ok("invention" => InventionSerializer.new(invention))
      # end

      desc "update container_section"
      params do
        requires :invention_id, type: Integer, desc: "invention_id"
        optional :draw, type: String, desc: "draw content"
        optional :significance, type: String, desc: "significance content"
        optional :landscape, type: String, desc: "landscape content"
        optional :problem_summary, type: String, desc: "problem_summary content"
        optional :gap, type: String, desc: "gap content"
        optional :problem_significance, type: String, desc: "problem_significance content"
      end
      put :update do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return data_not_found(MISSING_INV) if invention.nil?
        unless current_user.inventor?(invention) || current_user.co_inventor?(invention)
          return permission_denied(NOT_CO_INVENTOR_DENIED)
        end
        permit_params = ActionController::Parameters.new(params).permit(
          :draw, :significance, :landscape, :problem_summary, :gap, :problem_significance
        )
        container_section = invention.container_section || invention.create_container_section
        container_section.update_attributes(permit_params)
        resp_ok("invention" => InventionSerializer.new(invention))
      end

      # desc "delete container_section"
      # params do
      #   requires :id, type: Integer, desc: "container_section id"
      # end
      # delete :delete do
      #   authenticate!
      #   container_section = ContainerSection.find_by(id: params[:id])
      #   return data_not_found(MISSING_CS) if container_section.nil?
      #   invention = container_section.invention
      #   unless current_user.inventor?(invention) || current_user.co_inventor?(invention)
      #     return permission_denied(NOT_CO_INVENTOR_DENIED)
      #   end
      #   container_section.destroy
      #   resp_ok("invention" => InventionSerializer.new(invention))
      # end

    end
  end
end
