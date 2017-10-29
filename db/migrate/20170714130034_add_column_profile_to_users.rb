class AddColumnProfileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile, :text, limit: 500
  end
end
