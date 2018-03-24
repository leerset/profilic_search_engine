class AddBulkReadAccessToInvention < ActiveRecord::Migration[5.1]
  def change
    add_column :inventions, :bulk_read_access, :string, default: 'only-inventors', after: :action_note, index: true
  end
end
