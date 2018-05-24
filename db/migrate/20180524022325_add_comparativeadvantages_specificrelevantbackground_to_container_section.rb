class AddComparativeadvantagesSpecificrelevantbackgroundToContainerSection < ActiveRecord::Migration[5.1]
  def change
    add_column :container_sections, :comparativeadvantages_specificrelevantbackground, :text
    add_column :container_sections, :comparativeadvantages_specificrelevantbackground_completion, :boolean, default: false
  end
end
