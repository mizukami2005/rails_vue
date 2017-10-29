class RenameUserNameToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :user_name, :screen_name
  end
end
