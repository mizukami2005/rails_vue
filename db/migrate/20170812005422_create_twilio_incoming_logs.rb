class CreateTwilioIncomingLogs < ActiveRecord::Migration
  def change
    create_table :twilio_incoming_logs do |t|
      t.string :sid
      t.string :to
      t.string :from
      t.string :call_status
      t.references :user, index: true, foreign_key: true
      t.references :twilio_outgoing_log, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
