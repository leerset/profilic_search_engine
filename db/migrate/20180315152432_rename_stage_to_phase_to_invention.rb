class RenameStageToPhaseToInvention < ActiveRecord::Migration[5.1]
  def up
    rename_column :inventions, :stage, :phase
  end

  def down
    rename_column :inventions, :phase, :stage
  end
end
