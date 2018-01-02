class AddEmployerStreetsToAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :street2, :string, after: :address_type
    add_column :addresses, :street1, :string, after: :address_type
    add_column :addresses, :employer, :string, after: :address_type
  end
end
