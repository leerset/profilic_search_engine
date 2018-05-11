class CreateDownloadFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :download_files do |t|
      t.string :name, index: true
      t.string :code, index: true
      t.string :filepath
      t.boolean :enable
      t.attachment :download

      t.timestamps
    end
  end
end
