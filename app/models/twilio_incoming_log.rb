class TwilioIncomingLog < ActiveRecord::Base
  # 親
  belongs_to :user
  belongs_to :twilio_outgoing_log
  # before_create :create_tel_inquiry
  # has_one :twilio_outgoing_log
  before_create :change_status
  def self.create_log(user_id, call)
    incoming_params = {
      user_id: user_id,
      sid: call.sid,
      to: call.to,
      from: call.from,
      call_status: call.status,
    }
    twilio_incoming_log = self.new(incoming_params)
    twilio_incoming_log.save
  end

  private

  def change_status
    p "change_status"
    User.last.tel_inquiries.create(setting: true)

    # self.call_status = "sample" if self.twilio_outgoing_log.duration.to_i < 30
  end
end
