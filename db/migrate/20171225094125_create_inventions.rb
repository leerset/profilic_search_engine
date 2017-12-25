class CreateInventions < ActiveRecord::Migration[5.1]
  def change
    create_table :inventions do |t|
      t.references :organization, index: true
      t.string :name

      t.timestamps
    end
  end
end
