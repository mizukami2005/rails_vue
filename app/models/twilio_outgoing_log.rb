class TwilioOutgoingLog < ActiveRecord::Base
  # 子供
  belongs_to :user
  has_one :twilio_incoming_log

  after_create :create_incoming_log

  def self.create_log(params)
    out_going_params = {
      sid: params[:CallSid],
      parent_call_sid: params[:ParentCallSid],
      finished_call_time: params[:Timestamp],
      to: params[:To],
      from: params[:From],
      call_status: params[:CallStatus],
      duration: params[:CallDuration]
    }
    p "create log params"
    p out_going_params
    twilio_out_going_log = self.new(out_going_params)
    # twilio_out_going_log.save
  end

  def create_incoming_log
    p "create_incoming_log"
    TwilioIncomingLog.create(user_id: '1', sid: '1', to: '1', from: '1', call_status: '1', twilio_outgoing_log_id: 1)
  end
end
