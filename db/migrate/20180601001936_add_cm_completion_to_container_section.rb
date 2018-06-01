class AddCmCompletionToContainerSection < ActiveRecord::Migration[5.1]
  def change
    add_column :container_sections, :c_milestone_completion, :boolean, default: false
  end
end
