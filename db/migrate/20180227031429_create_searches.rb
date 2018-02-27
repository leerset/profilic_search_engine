class CreateSearches < ActiveRecord::Migration[5.1]
  def change
    create_table :searches do |t|
      t.string :title, index:true
      t.string :url, index:true
      t.string :note, index:true
      t.string :tag, index:true

      t.timestamps
    end
  end
end
