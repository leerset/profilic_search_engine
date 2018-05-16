class RenameCComparativeAdvantage < ActiveRecord::Migration[5.1]
  def up
    rename_column :container_sections, :c_comparative_advantage_completion, :c_comparativeadvantage_completion
    remove_column :c_comparative_advantages, :boolean
    rename_table :c_comparative_advantages, :c_comparativeadvantages
  end

  def down
    rename_column :container_sections, :c_comparativeadvantage_completion, :c_comparative_advantage_completion
    rename_table :c_comparativeadvantages, :c_comparative_advantages
  end

end
