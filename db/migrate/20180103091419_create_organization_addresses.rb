class CreateOrganizationAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :organization_addresses do |t|
      t.references :organization, index: true
      t.references :address, index: true

      t.timestamps
    end
  end
end
