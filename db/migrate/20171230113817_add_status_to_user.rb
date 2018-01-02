class AddStatusToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :status, :string, after: :email, default: 'Active'
    add_column :users, :citizenship, :string, after: :email
  end
end
