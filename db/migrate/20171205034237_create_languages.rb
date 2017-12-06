class CreateLanguages < ActiveRecord::Migration[5.1]
  def change
    create_table :languages do |t|
      t.string :name, index: true
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
