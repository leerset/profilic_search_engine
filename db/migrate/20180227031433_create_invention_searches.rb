class CreateInventionSearches < ActiveRecord::Migration[5.1]
  def change
    create_table :invention_searches do |t|
      t.references :invention, index: true
      t.references :search, index: true

      t.timestamps
    end
  end
end
