class CreateInventionUploadFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :invention_upload_files do |t|
      t.references :invention, index: true
      t.references :upload_file, index: true
      t.string :status, index: true

      t.timestamps
    end
  end
end
