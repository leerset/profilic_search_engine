class CreateSolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :solutions do |t|
      t.references :concept, index: true
      t.text :summary
      t.text :significance
      t.integer :created_by, index: true
      t.integer :updated_by, index: true

      t.timestamps
    end
  end
end
