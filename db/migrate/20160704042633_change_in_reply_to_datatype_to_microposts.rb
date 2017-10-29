class ChangeInReplyToDatatypeToMicroposts < ActiveRecord::Migration
  def change
    change_column :microposts, :in_reply_to, :integer
  end
end
