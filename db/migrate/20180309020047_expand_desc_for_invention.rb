class ExpandDescForInvention < ActiveRecord::Migration[5.1]
  def up
    change_column :inventions, :description, :text
  end

  def down
    change_column :inventions, :description, :text
  end
end
