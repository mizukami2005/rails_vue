class AddIndexToUsersScreenName < ActiveRecord::Migration
  def change
    add_index :users, :screen_name, unique: true
  end
end
