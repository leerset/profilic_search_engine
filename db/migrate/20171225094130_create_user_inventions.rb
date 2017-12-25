class CreateUserInventions < ActiveRecord::Migration[5.1]
  def change
    create_table :user_inventions do |t|
      t.references :user, index: true
      t.references :invention, index: true
      t.references :role, index: true

      t.timestamps
    end
  end
end
