class AddCompletionsToContainerSection < ActiveRecord::Migration[5.1]
  def change
    add_column :container_sections, :draw_completion, :boolean, default: false
    add_column :container_sections, :significance_completion, :boolean, default: false
    add_column :container_sections, :landscape_completion, :boolean, default: false
    add_column :container_sections, :problem_summary_completion, :boolean, default: false
    add_column :container_sections, :gap_completion, :boolean, default: false
    add_column :container_sections, :problem_significance_completion, :boolean, default: false
  end
end
