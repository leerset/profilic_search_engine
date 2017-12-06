class CreatePhones < ActiveRecord::Migration[5.1]
  def change
    create_table :phones do |t|
      t.references :address, index: true
      t.string :phone_type, index: true
      t.string :phone_number
      t.boolean :enable, index: true

      t.timestamps
    end
  end
end
