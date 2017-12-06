class CreateUserLanguages < ActiveRecord::Migration[5.1]
  def change
    create_table :user_languages do |t|
      t.references :user, index: true
      t.references :language, index: true

      t.timestamps
    end
  end
end
