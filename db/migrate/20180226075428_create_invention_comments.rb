class CreateInventionComments < ActiveRecord::Migration[5.1]
  def change
    create_table :invention_comments do |t|
      t.references :invention, index: true
      t.references :comment, index: true

      t.timestamps
    end
  end
end
