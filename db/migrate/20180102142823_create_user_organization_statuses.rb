class CreateUserOrganizationStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :user_organization_statuses do |t|
      t.references :user, index: true
      t.references :organization, index: true
      t.string :status, default: 'Active'
      t.string :title
      t.string :phone

      t.timestamps
    end
  end
end
