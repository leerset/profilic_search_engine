class CreateContainerSectionComments < ActiveRecord::Migration[5.1]
  def change
    create_table :container_section_comments do |t|
      t.references :container_section, index: true
      t.references :comment, index: true
      t.string :section_name, index: true

      t.timestamps
    end
  end
end
