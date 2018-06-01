class RenameCmCompletionsToContainerSection < ActiveRecord::Migration[5.1]
  def up
    rename_column :container_sections, :c_milestone_completion, :c_milestones_completion
  end

  def down
    rename_column :container_sections, :c_milestones_completion, :c_milestone_completion
  end
end
