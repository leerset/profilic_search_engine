class CreateTimeZones < ActiveRecord::Migration[5.1]
  def change
    create_table :time_zones do |t|
      t.string :name, index: true
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
