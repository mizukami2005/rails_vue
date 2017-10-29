class RenameInReplyToMicroposts < ActiveRecord::Migration
  def change
    rename_column :microposts, :in_reply_to, :reply_to
  end
end
