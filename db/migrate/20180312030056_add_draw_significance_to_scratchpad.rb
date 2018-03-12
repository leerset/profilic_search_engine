class AddDrawSignificanceToScratchpad < ActiveRecord::Migration[5.1]
  def up
    add_column :scratchpads, :draw, :text, after: :html
    add_column :scratchpads, :significance, :text, after: :draw
  end

  def down
    remove_column :scratchpads, :draw
    remove_column :scratchpads, :significance
  end
end
