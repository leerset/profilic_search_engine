class AddLastUserForInvention < ActiveRecord::Migration[5.1]
  def change
    add_reference :inventions, :user
  end
end
