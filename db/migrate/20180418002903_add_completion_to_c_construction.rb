class AddCompletionToCConstruction < ActiveRecord::Migration[5.1]
  def change
    add_column :c_constructions, :completion, :boolean, default: false
  end
end
