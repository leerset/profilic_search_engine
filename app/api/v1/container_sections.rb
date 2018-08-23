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
        optional :comparativeadvantages_specificrelevantbackground, type: String, desc: "comparativeadvantages_specificrelevantbackground content"

        optional :economics_need, type: String, desc: "economics_need content"
        optional :economics_enduser, type: String, desc: "economics_enduser content"
        optional :economics_keyresources, type: String, desc: "economics_keyresources content"
        optional :economics_capitalexpenditure, type: String, desc: "economics_capitalexpenditure content"
        optional :references, type: String, desc: "references content"

        optional :economics_estimatedincrementalcost, type: String, desc: "economics_estimatedincrementalcost content"
        optional :economics_feasiblyeconomical, type: String, desc: "economics_feasiblyeconomical content"
        optional :economics_whomake, type: String, desc: "economics_whomake content"
        optional :economics_howmakemoney, type: String, desc: "economics_howmakemoney content"
        optional :economics_howdelivered, type: String, desc: "economics_howdelivered content"
        optional :economics_economicburden, type: String, desc: "economics_economicburden content"
        optional :economics_currentsolutioncosts, type: String, desc: "economics_currentsolutioncosts content"
        optional :economics_consumercosts, type: String, desc: "economics_consumercosts content"

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
        optional :c_comparativeadvantages, type: Array do
          optional :id, type: String, desc: "c_comparativeadvantage id"
          optional :delete, type: Boolean, desc: "c_comparativeadvantage delete"
          optional :c_type, type: String, desc: "c_comparativeadvantage type"
          optional :completion, type: Boolean, desc: "c_comparativeadvantage completion"
          optional :competing_howworks, type: String, desc: "c_comparativeadvantage competing_howworks"
          optional :shortcomings, type: String, desc: "c_comparativeadvantage shortcomings"
          optional :howovercomes_shortcomings, type: String, desc: "c_comparativeadvantage howovercomes_shortcomings"
        end
        optional :c_developments, type: Array do
          optional :id, type: String, desc: "c_development id"
          optional :delete, type: Boolean, desc: "c_development delete"
          optional :c_type, type: String, desc: "c_development type"
          optional :completion, type: Boolean, desc: "c_development completion"
          optional :title, type: String, desc: "c_development title"
          optional :key_points, type: String, desc: "c_development key_points"
          optional :resources_needed, type: String, desc: "c_development resources_needed"
          optional :deliverables, type: String, desc: "c_development deliverables"
          optional :measure_of_success, type: String, desc: "c_development measure_of_success"
          optional :key_risks, type: String, desc: "c_development key_risks"
          optional :suggested_approach, type: String, desc: "c_development suggested_approach"
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
        c_comparativeadvantages = params[:c_comparativeadvantages].presence || []
        c_comparativeadvantages.each do |cc|
          c_permit_params = ActionController::Parameters.new(cc).permit(
            :c_type, :completion, :competing_howworks, :shortcomings, :howovercomes_shortcomings
          )
          c_comparativeadvantage = CComparativeadvantage.find_by_id(cc[:id])
          if c_comparativeadvantage.present?
            if cc[:delete].present? && cc[:delete] == true
              c_comparativeadvantage.destroy
            else
              c_comparativeadvantage.update_attributes(c_permit_params)
            end
          else
            container_section.c_comparativeadvantages.create(c_permit_params)
          end
        end
        c_developments = params[:c_developments].presence || []
        c_developments.each do |cc|
          c_permit_params = ActionController::Parameters.new(cc).permit(
            :c_type, :completion, :title, :key_points, :resources_needed, :deliverables, :measure_of_success, :key_risks, :suggested_approach
          )
          c_development = CDevelopment.find_by_id(cc[:id])
          if c_development.present?
            if cc[:delete].present? && cc[:delete] == true
              c_development.destroy
            else
              c_development.update_attributes(c_permit_params)
            end
          else
            container_section.c_developments.create(c_permit_params)
          end
        end
        resp_ok("invention" => InventionSerializer.new(invention))
      end

      desc "update container_section attribute"
      params do
        requires :invention_id, type: Integer, desc: "invention_id"
        requires :name, type: String, desc: "attribute name"
        requires :content, type: String, desc: "attribute content"
      end
      put :update_attribute do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return data_not_found(MISSING_INV) if invention.nil?
        unless current_user.edit_access?(invention)
          return permission_denied('Not permission to edit')
        end
        attribute_name = params[:name]
        attribute_content = params[:content]
        if attribute_name.downcase == 'summary'
          invention.update(description: attribute_content)
        end
        if ContainerSection::SECTION_NAMES.include?(attribute_name)
          container_section = invention.container_section || invention.create_container_section
          container_section.update_attributes(attribute_name.to_sym => attribute_content)
        end
        resp_ok("invention" => InventionSerializer.new(invention))
      end

      desc "update container_section c_constructions"
      params do
        requires :invention_id, type: Integer, desc: "invention_id"
        requires :c_constructions, type: Array do
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
      end
      put :update_constructions do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return data_not_found(MISSING_INV) if invention.nil?
        unless current_user.edit_access?(invention)
          return permission_denied('Not permission to edit')
        end
        container_section = invention.container_section || invention.create_container_section
        c_constructions = params[:c_constructions]
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
        resp_ok("invention" => InventionSerializer.new(invention))
      end

      desc "update container_section c_comparativeadvantages"
      params do
        requires :invention_id, type: Integer, desc: "invention_id"
        requires :c_comparativeadvantages, type: Array do
          optional :id, type: String, desc: "c_comparativeadvantage id"
          optional :delete, type: Boolean, desc: "c_comparativeadvantage delete"
          optional :c_type, type: String, desc: "c_comparativeadvantage type"
          optional :completion, type: Boolean, desc: "c_comparativeadvantage completion"
          optional :competing_howworks, type: String, desc: "c_comparativeadvantage competing_howworks"
          optional :shortcomings, type: String, desc: "c_comparativeadvantage shortcomings"
          optional :howovercomes_shortcomings, type: String, desc: "c_comparativeadvantage howovercomes_shortcomings"
        end
      end
      put :update_comparativeadvantages do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return data_not_found(MISSING_INV) if invention.nil?
        unless current_user.edit_access?(invention)
          return permission_denied('Not permission to edit')
        end
        container_section = invention.container_section || invention.create_container_section
        c_comparativeadvantages = params[:c_comparativeadvantages].presence || []
        c_comparativeadvantages.each do |cc|
          c_permit_params = ActionController::Parameters.new(cc).permit(
            :c_type, :completion, :competing_howworks, :shortcomings, :howovercomes_shortcomings
          )
          c_comparativeadvantage = CComparativeadvantage.find_by_id(cc[:id])
          if c_comparativeadvantage.present?
            if cc[:delete].present? && cc[:delete] == true
              c_comparativeadvantage.destroy
            else
              c_comparativeadvantage.update_attributes(c_permit_params)
            end
          else
            container_section.c_comparativeadvantages.create(c_permit_params)
          end
        end
        resp_ok("invention" => InventionSerializer.new(invention))
      end

      desc "update container_section c_developments"
      params do
        requires :invention_id, type: Integer, desc: "invention_id"
        requires :c_developments, type: Array do
          optional :id, type: String, desc: "c_development id"
          optional :delete, type: Boolean, desc: "c_development delete"
          optional :c_type, type: String, desc: "c_development type"
          optional :completion, type: Boolean, desc: "c_development completion"
          optional :title, type: String, desc: "c_development title"
          optional :key_points, type: String, desc: "c_development key_points"
          optional :resources_needed, type: String, desc: "c_development resources_needed"
          optional :deliverables, type: String, desc: "c_development deliverables"
          optional :measure_of_success, type: String, desc: "c_development measure_of_success"
          optional :key_risks, type: String, desc: "c_development key_risks"
          optional :suggested_approach, type: String, desc: "c_development suggested_approach"
        end
      end
      put :update_developments do
        authenticate!
        invention = Invention.find_by(id: params[:invention_id])
        return data_not_found(MISSING_INV) if invention.nil?
        unless current_user.edit_access?(invention)
          return permission_denied('Not permission to edit')
        end
        container_section = invention.container_section || invention.create_container_section
        c_developments = params[:c_developments].presence || []
        c_developments.each do |cc|
          c_permit_params = ActionController::Parameters.new(cc).permit(
            :c_type, :completion, :title, :key_points, :resources_needed, :deliverables, :measure_of_success, :key_risks, :suggested_approach
          )
          c_development = CDevelopment.find_by_id(cc[:id])
          if c_development.present?
            if cc[:delete].present? && cc[:delete] == true
              c_development.destroy
            else
              c_development.update_attributes(c_permit_params)
            end
          else
            container_section.c_developments.create(c_permit_params)
          end
        end
        resp_ok("invention" => InventionSerializer.new(invention))
      end

      desc "update container_section completion"
      params do
        requires :section_name, type: String, desc: "draw significance landscape problem_summary gap problem_significance summary / c_construction c_comparativeadvantages c_development"
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
            component = ContainerSection::COMPONENT_CLASS_MAPPING[section_name].find_by(id: component_id)
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

      desc "update container_section completion"
      params do
        requires :section_name, type: String, desc: "draw significance landscape problem_summary gap problem_significance summary / c_construction c_comparativeadvantages c_development"
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
            component = ContainerSection::COMPONENT_CLASS_MAPPING[section_name].find_by(id: component_id)
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
