class CreateUserAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :user_addresses do |t|
      t.references :user, index: true
      t.references :address, index: true

      t.timestamps
    end
  end
end
