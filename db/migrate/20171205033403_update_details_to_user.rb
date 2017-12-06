class UpdateDetailsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :lastname, :string, after: :id
    add_column :users, :firstname, :string, after: :id

    add_column :users, :personal_summary, :text, after: :email
    add_column :users, :resume_filepath, :string, after: :email
    add_column :users, :time_zone, :string, after: :email
    add_column :users, :employer, :string, after: :email
    add_column :users, :screen_name, :string, after: :email

    add_column :users, :enable, :boolean, default: true
  end
end
