class AddTypeToRole < ActiveRecord::Migration[5.1]
  def change
    add_column :roles, :role_type, :string, after: :code
  end
end
