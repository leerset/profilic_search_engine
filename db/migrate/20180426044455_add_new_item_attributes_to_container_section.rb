class AddNewItemAttributesToContainerSection < ActiveRecord::Migration[5.1]
  def change
    add_column :container_sections, :construction_howused, :text
    add_column :container_sections, :construction_prototype, :text
    add_column :container_sections, :comparativeadvantages_innovativeaspects, :text
    add_column :container_sections, :comparativeadvantages_advantagessummary, :text
    add_column :container_sections, :comparativeadvantages_relevantbackground, :text

    add_column :container_sections, :construction_howused_completion, :boolean, default: false
    add_column :container_sections, :construction_prototype_completion, :boolean, default: false
    add_column :container_sections, :comparativeadvantages_innovativeaspects_completion, :boolean, default: false
    add_column :container_sections, :comparativeadvantages_advantagessummary_completion, :boolean, default: false
    add_column :container_sections, :comparativeadvantages_relevantbackground_completion, :boolean, default: false
  end
end
