class ExpandDescForOpportunity < ActiveRecord::Migration[5.1]
  def up
    change_column :invention_opportunities, :short_description, :text
  end

  def down
    change_column :invention_opportunities, :short_description, :string, :limit => 255
  end

end
