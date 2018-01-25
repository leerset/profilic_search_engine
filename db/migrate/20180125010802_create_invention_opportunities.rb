class CreateInventionOpportunities < ActiveRecord::Migration[5.1]
  def change
    create_table :invention_opportunities do |t|
      t.references :organization, index: true
      t.string :title, index: true
      t.date :closing_date, index: true
      t.string :short_description
      t.string :status, index: true

      t.timestamps
    end
  end
end
