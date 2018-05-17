class RenameCComparativeAdvantageTwo < ActiveRecord::Migration[5.1]
  def up
    rename_column :container_sections, :c_comparativeadvantage_completion, :c_comparativeadvantages_completion
  end

  def down
    rename_column :container_sections, :c_comparativeadvantages_completion, :c_comparativeadvantage_completion
  end
end
