class CreateCMilestones < ActiveRecord::Migration[5.1]
  def change
    create_table :c_milestones do |t|
      t.references :container_section, index: true
      t.string :c_type, index: true
      t.text :title
      t.text :key_points
      t.text :resources_needed
      t.text :deliverables
      t.text :measure_of_success
      t.text :key_risks
      t.text :suggested_approach

      t.timestamps
    end
  end
end
