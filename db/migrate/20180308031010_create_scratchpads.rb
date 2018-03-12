class CreateScratchpads < ActiveRecord::Migration[5.1]
  def change
    create_table :scratchpads do |t|
      t.references :invention, index: true
      t.text :html

      t.timestamps
    end
  end
end
