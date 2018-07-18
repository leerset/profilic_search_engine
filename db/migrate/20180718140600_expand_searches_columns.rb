class ExpandSearchesColumns < ActiveRecord::Migration[5.1]
  def up
    change_column :searches, :title, :string, :limit => 1024
    change_column :searches, :url, :string, :limit => 1024
    change_column :searches, :note, :string, :limit => 1024
    change_column :searches, :tag, :string, :limit => 1024
  end

  def down
    change_column :searches, :title, :string, :limit => 255
    change_column :searches, :url, :string, :limit => 255
    change_column :searches, :note, :string, :limit => 255
    change_column :searches, :tag, :string, :limit => 255
  end

end
