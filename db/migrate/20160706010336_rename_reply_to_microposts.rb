class RenameReplyToMicroposts < ActiveRecord::Migration
  def change
    rename_column :microposts, :reply_to, :reply_to_user_id
  end
end
