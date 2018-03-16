class AddAccessToUserInvention < ActiveRecord::Migration[5.1]
  def change
    add_column :user_inventions, :access, :string, after: :role_id
  end
end
