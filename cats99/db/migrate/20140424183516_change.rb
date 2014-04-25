class Change < ActiveRecord::Migration
  def change
    change_column :users, :user_name, :string, null: false, unique: true
    change_column :users, :session_token, :string, null: false, unique: true
  end
end
