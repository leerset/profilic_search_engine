class AddInventionOpportunityAndTitleDescriptionToInvention < ActiveRecord::Migration[5.1]
  def change
    add_reference :inventions, :invention_opportunity, after: :id, index: true
    add_column :inventions, :title, :string, after: :name, index: true
    add_column :inventions, :description, :string, after: :title
  end
end
