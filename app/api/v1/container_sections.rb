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
        optional :summary, type: String, desc: "summary content"
        optional :construction_howused, type: String, desc: "construction_howused content"
        optional :construction_prototype, type: String, desc: "construction_prototype content"

        optional :comparativeadvantages_innovativeaspects, type: String, desc: "comparativeadvantages_innovativeaspects content"
        optional :comparativeadvantages_advantagessummary, type: String, desc: "comparativeadvantages_advantagessummary content"
        optional :comparativeadvantages_relevantbackground, type: String, desc: "comparativeadvantages_relevantbackground content"

        optional :economics_need, type: String, desc: "economics_need content"
        optional :economics_enduser, type: String, desc: "economics_enduser content"
        optional :economics_keyresources, type: String, desc: "economics_keyresources content"
        optional :economics_capitalexpenditure, type: String, desc: "economics_capitalexpenditure content"
        optional :references, type: String, desc: "references content"

        optional :c_constructions, type: Array do
          optional :id, type: String, desc: "c_construction id"
          optional :delete, type: Boolean, desc: "c_construction delete"
          optional :c_type, type: String, desc: "c_construction type"
          optional :completion, type: Boolean, desc: "c_construction completion"
          optional :ideal_example, type: String, desc: "c_construction ideal_example"
          optional :properties, type: String, desc: "c_construction properties"
          optional :how_made, type: String, desc: "c_construction how_made"
          optional :innovative_aspects, type: String, desc: "c_construction innovative_aspects"
          optional :why_hasnt_done_before, type: String, desc: "c_construction why_hasnt_done_before"
        end
        optional :c_comparative_advantages, type: Array do
          optional :id, type: String, desc: "c_comparative_advantage id"
          optional :delete, type: Boolean, desc: "c_comparative_advantage delete"
          optional :c_type, type: String, desc: "c_comparative_advantage type"
          optional :completion, type: Boolean, desc: "c_comparative_advantage completion"
          optional :competing_howworks, type: String, desc: "c_comparative_advantage competing_howworks"
          optional :shortcomings, type: String, desc: "c_comparative_advantage shortcomings"
          optional :howovercomes_shortcomings, type: String, desc: "c_comparative_advantage howovercomes_shortcomings"
        end
      end
      put :update do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return data_not_found(MISSING_INV) if invention.nil?
        unless current_user.edit_access?(invention)
          return permission_denied('Not permission to edit')
        end
        if (summary = params[:summary]).present?
          invention.update(description: summary)
        end
        permit_params = ActionController::Parameters.new(params).permit(
          ContainerSection::SECTION_NAMES.map(&:to_sym)
        )
        container_section = invention.container_section || invention.create_container_section
        container_section.update_attributes(permit_params)
        c_constructions = params[:c_constructions].presence || []
        c_constructions.each do |cc|
          c_permit_params = ActionController::Parameters.new(cc).permit(
            :c_type, :completion, :ideal_example, :properties, :how_made, :innovative_aspects, :why_hasnt_done_before
          )
          c_construction = CConstruction.find_by_id(cc[:id])
          if c_construction.present?
            if cc[:delete].present? && cc[:delete] == true
              c_construction.destroy
            else
              c_construction.update_attributes(c_permit_params)
            end
          else
            container_section.c_constructions.create(c_permit_params)
          end
        end
        c_comparative_advantages = params[:c_comparative_advantages].presence || []
        c_comparative_advantages.each do |cc|
          c_permit_params = ActionController::Parameters.new(cc).permit(
            :c_type, :completion, :competing_howworks, :shortcomings, :howovercomes_shortcomings
          )
          c_comparative_advantage = CConstruction.find_by_id(cc[:id])
          if c_comparative_advantage.present?
            if cc[:delete].present? && cc[:delete] == true
              c_comparative_advantage.destroy
            else
              c_comparative_advantage.update_attributes(c_permit_params)
            end
          else
            container_section.c_comparative_advantages.create(c_permit_params)
          end
        end
        resp_ok("invention" => InventionSerializer.new(invention))
      end

      desc "update container_section completion"
      params do
        requires :section_name, type: String, desc: "draw significance landscape problem_summary gap problem_significance summary / c_construction c_comparative_advantage"
        optional :invention_id, type: Integer, desc: "invention_id"
        optional :component_id, type: Integer, desc: "component id"
        exactly_one_of :invention_id, :component_id
        requires :completion, type: Boolean, desc: "section completion"
      end
      put :update_completion do
        authenticate!
        section_name = params[:section_name]
        invention_id = params[:invention_id]
        component_id = params[:component_id]
        if invention_id.present?
          invention = Invention.find_by(id: invention_id)
          return data_not_found(MISSING_INV) if invention.nil?
          unless current_user.edit_access?(invention)
            return permission_denied('Not permission to edit')
          end
          container_section = invention.container_section || invention.create_container_section
          case section_name
          when *ContainerSection::SECTION_NAMES
            container_section.update("#{section_name}_completion" => params[:completion])
          when *ContainerSection::COMPONENT_NAMES
            container_section.update("#{section_name}_completion" => params[:completion])
          else
            return permission_denied("unknown section name")
          end
        else
          case section_name
          when *ContainerSection::COMPONENT_NAMES
            component = section_name.camelcase.constantize.find_by(id: component_id)
            return data_not_found(MISSING_COMPONENT) if component.nil?
            invention = component.container_section.invention
            return data_not_found(MISSING_INV) if invention.nil?
            unless current_user.edit_access?(invention)
              return permission_denied('Not permission to edit')
            end
            component.update(completion: params[:completion])
          else
            return permission_denied("unknown section name")
          end
        end
        resp_ok("invention" => InventionSerializer.new(invention))
      end

      desc "add container_section comment"
      params do
        requires :invention_id, type: Integer, desc: "invention_id"
        requires :section_name, type: String, desc: "draw significance landscape problem_summary gap problem_significance"
        requires :content, type: String, desc: "section comment content"
      end
      post :add_comment do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return data_not_found(MISSING_INV) if invention.nil?
        unless current_user.read_access?(invention)
          return permission_denied('No permission to add comments')
        end
        container_section = invention.container_section || invention.create_container_section
        case params[:section_name]
        when *ContainerSection::SECTION_NAMES
          container_section.send("#{params[:section_name]}_comments").create(user: current_user, content: params[:content])
        when *ContainerSection::COMPONENT_NAMES
          container_section.send("#{params[:section_name]}_comments").create(user: current_user, content: params[:content])
        else
          return permission_denied("unknown section name")
        end
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
