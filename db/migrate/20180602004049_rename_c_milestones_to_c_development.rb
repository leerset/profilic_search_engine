class RenameCMilestonesToCDevelopment < ActiveRecord::Migration[5.1]
  def up
    rename_column :container_sections, :c_milestones_completion, :c_development_completion
    rename_table :c_milestones, :c_developments
  end

  def down
    rename_column :container_sections, :c_development_completion, :c_milestones_completion
    rename_table :c_developments, :c_milestones
  end
end
