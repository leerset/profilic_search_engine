class AddComparativeAdvantageCompletionToContainerSection < ActiveRecord::Migration[5.1]
  def change
    add_column :container_sections, :c_comparative_advantage_completion, :boolean, default: false
  end
end
