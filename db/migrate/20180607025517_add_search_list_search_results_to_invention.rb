class AddSearchListSearchResultsToInvention < ActiveRecord::Migration[5.1]
  def change
    add_column :inventions, :search_list, :string, after: :description, index: true
    add_column :inventions, :search_results, :string, after: :description, index: true
  end
end
