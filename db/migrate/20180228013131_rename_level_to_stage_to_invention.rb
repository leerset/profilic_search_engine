class RenameLevelToStageToInvention < ActiveRecord::Migration[5.1]
  def up
    rename_column :inventions, :level, :stage
  end

  def down
    rename_column :inventions, :stage, :level
  end
end
