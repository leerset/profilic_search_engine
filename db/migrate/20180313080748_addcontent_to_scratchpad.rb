class AddcontentToScratchpad < ActiveRecord::Migration[5.1]
  def up
    add_column :scratchpads, :content, :text, after: :html
  end

  def down
    remove_column :scratchpads, :content
  end
end
