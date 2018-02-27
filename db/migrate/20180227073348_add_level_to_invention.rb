class AddLevelToInvention < ActiveRecord::Migration[5.1]
  def change
    add_column :inventions, :level, :string, after: :action
  end
end
