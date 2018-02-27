class AddActionNoteToInvention < ActiveRecord::Migration[5.1]
  def change
    add_column :inventions, :action_note, :string, limit: 500, after: :action
  end
end
