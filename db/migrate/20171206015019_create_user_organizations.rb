class CreateUserOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_organizations do |t|
      t.references :user, index: true
      t.references :organization, index: true
      t.references :role, index: true

      t.timestamps
    end
  end
end
