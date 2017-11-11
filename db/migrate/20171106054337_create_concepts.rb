class CreateConcepts < ActiveRecord::Migration[5.1]
  def change
    create_table :concepts do |t|
      t.references :user, index: true
      t.string :url
      t.text :summary
      t.integer :created_by, index: true

      t.timestamps
    end
  end
end
