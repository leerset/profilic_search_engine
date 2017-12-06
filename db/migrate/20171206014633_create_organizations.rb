class CreateOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :organizations do |t|
      t.string :name, index: true
      t.string :code
      t.string :time_zone
      t.string :summary

      t.timestamps
    end
  end
end
