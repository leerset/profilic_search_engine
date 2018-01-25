class CreateUploadFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :upload_files do |t|
      t.string :name, index: true
      t.string :code
      t.string :filepath, index: true
      t.boolean :enable, index: true

      t.timestamps
    end
  end
end
