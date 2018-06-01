class AddCompletionToCm < ActiveRecord::Migration[5.1]
  def change
    add_column :c_milestones, :completion, :boolean, default: false
  end
end
