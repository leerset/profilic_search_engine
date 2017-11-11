class CreateAuths < ActiveRecord::Migration[5.1]
  def change
    create_table :auths do |t|
      t.references :user, index: true
      t.string :secure_random

      t.timestamps
    end
  end
end
