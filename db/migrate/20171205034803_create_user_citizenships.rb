class CreateUserCitizenships < ActiveRecord::Migration[5.1]
  def change
    create_table :user_citizenships do |t|
      t.references :user, index: true
      t.references :citizenship, index: true

      t.timestamps
    end
  end
end
