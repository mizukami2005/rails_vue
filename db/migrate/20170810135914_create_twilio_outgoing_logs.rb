class CreateTwilioOutgoingLogs < ActiveRecord::Migration
  def change
    create_table :twilio_outgoing_logs do |t|
      t.string :sid
      t.string :parent_call_sid
      t.datetime :finished_call_time
      t.string :to
      t.string :from
      t.string :call_status
      t.string :duration
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
