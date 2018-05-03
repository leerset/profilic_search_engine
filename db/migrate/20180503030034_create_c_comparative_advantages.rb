class CreateCComparativeAdvantages < ActiveRecord::Migration[5.1]
  def change
    create_table :c_comparative_advantages do |t|
      t.references :container_section, index: true
      t.string :c_type, index: true
      t.text :competing_howworks
      t.text :shortcomings
      t.text :howovercomes_shortcomings
      t.boolean :completion, :boolean, default: false

      t.timestamps
    end
  end
end
