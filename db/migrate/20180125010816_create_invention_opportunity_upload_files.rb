class CreateInventionOpportunityUploadFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :invention_opportunity_upload_files do |t|
      t.references :invention_opportunity, index: {name: :invention_opportunity_id}
      t.references :upload_file, index: true
      t.string :status, index: true

      t.timestamps
    end
  end
end
