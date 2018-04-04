class AddKeywordsToInvention < ActiveRecord::Migration[5.1]
  def change
    add_column :inventions, :keywords, :string, after: :description, index: true
  end
end
