class CreateCConstructions < ActiveRecord::Migration[5.1]
  def change
    create_table :c_constructions do |t|
      t.references :container_section, index: true
      t.string :c_type, index: true
      t.text :ideal_example
      t.text :properties
      t.text :how_made
      t.text :innovative_aspects
      t.text :why_hasnt_done_before

      t.timestamps
    end
  end
end
