class AddCommentStatusArchiveToInvention < ActiveRecord::Migration[5.1]
  def change
    add_column :inventions, :comment_status, :string, default: 'nobody', after: :action_note
    add_column :inventions, :archived, :boolean, default: false, after: :action_note
  end
end
