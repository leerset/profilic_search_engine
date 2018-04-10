class AddSummaryToContainerSection < ActiveRecord::Migration[5.1]
  def change
    add_column :container_sections, :summary, :text
    add_column :container_sections, :summary_completion, :boolean, default: false
  end
end
