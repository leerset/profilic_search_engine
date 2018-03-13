class CreateContainerSections < ActiveRecord::Migration[5.1]
  def change
    create_table :container_sections do |t|
      t.references :invention, index: true
      t.text :draw
      t.text :significance

      t.timestamps
    end
  end
end
