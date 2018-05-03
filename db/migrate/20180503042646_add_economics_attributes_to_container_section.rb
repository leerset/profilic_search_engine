class AddEconomicsAttributesToContainerSection < ActiveRecord::Migration[5.1]
  def change
    add_column :container_sections, :economics_need, :text
    add_column :container_sections, :economics_enduser, :text
    add_column :container_sections, :economics_keyresources, :text
    add_column :container_sections, :economics_capitalexpenditure, :text
    add_column :container_sections, :references, :text

    add_column :container_sections, :economics_need_completion, :boolean, default: false
    add_column :container_sections, :economics_enduser_completion, :boolean, default: false
    add_column :container_sections, :economics_keyresources_completion, :boolean, default: false
    add_column :container_sections, :economics_capitalexpenditure_completion, :boolean, default: false
    add_column :container_sections, :references_completion, :boolean, default: false
  end
end
