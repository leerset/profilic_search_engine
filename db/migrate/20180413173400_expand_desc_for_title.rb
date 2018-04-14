class ExpandDescForTitle < ActiveRecord::Migration[5.1]
  def up
    change_column :invention_opportunities, :title, :string, :limit => 500
  end

  def down
    change_column :invention_opportunities, :title, :string, :limit => 255
  end

end
