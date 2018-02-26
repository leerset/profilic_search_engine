class AddActionToInvention < ActiveRecord::Migration[5.1]
  def change
    add_column :inventions, :action, :string, after: :description, index: true
  end
end
