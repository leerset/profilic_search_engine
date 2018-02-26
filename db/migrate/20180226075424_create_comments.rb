class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.string :content, limit: 500

      t.timestamps
    end
  end
end
