class AddCodeIndexToRole < ActiveRecord::Migration[5.1]
  def change
    add_index :roles, :code
  end
end
