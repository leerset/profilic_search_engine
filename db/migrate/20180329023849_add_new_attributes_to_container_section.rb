class AddNewAttributesToContainerSection < ActiveRecord::Migration[5.1]
  def change
    add_column :container_sections, :landscape, :text
    add_column :container_sections, :problem_summary, :text
    add_column :container_sections, :gap, :text
    add_column :container_sections, :problem_significance, :text
  end
end
