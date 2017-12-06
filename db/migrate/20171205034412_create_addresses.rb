class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :address_type, index: true
      t.boolean :primary
      t.string :street_address
      t.string :city
      t.string :state_province
      t.string :country
      t.string :postal_code
      t.boolean :enable, index: true

      t.timestamps
    end
  end
end
