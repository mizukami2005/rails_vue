class TwiliosController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    p "index"
    p params

    @client = Twilio::REST::Client.new
    sid = 'CA3642e6263315e620dc186b806f7327aas'
    begin
      @call = Twilio::REST::Client.new.api.calls(sid).fetch
    rescue Twilio::REST::RestError => e
      p "error"
      p e
      raise e.message
    end
    p "call"
    p @call

    # ActiveRecord::Base.transaction do
    #   TwilioOutgoingLog.create!(sid: '1', parent_call_sid: '2', finished_call_time: Time.zone.now,to: '1', from: '1', call_status: '1', duration: '1', user_id: 1)
    #   # TwilioIncomingLog.create!(user_id: '1', sid: '1', to: '1', from: '1', call_status: '1', twilio_outgoing_log_id: 1)
    #   p "create aaaaaaaaaa"
    # end

    # ここで作成すればOK
    response = Twilio::TwiML::VoiceResponse.new
    response.dial(caller_id: '+815031886593') do |dial|
      dial.number('+818016015579', status_callback: twilios_create_outgoing_log_url, status_callback_method: 'POST')
    end
    render xml: response.to_s
  end

  def create
    p "incom create"
    p params
    # if User.last.twilio_incoming_logs.create_log(twilio_incoming_log_params)
    #   p "create log"
    # else
    #   p "not create log"
    # end
    render nothing: true
  end

  def create_outgoing_log
    p "out going"

    outgoing_log = User.last.twilio_outgoing_logs.create_log(twilio_outgoing_log_params)

    if outgoing_log.save
      p "create log"
      @client = Twilio::REST::Client.new
      @call = @client.api.calls(params[:ParentCallSid]).fetch
      p "call"
      p @call.from
      # @call.twilio_incoming_log.create(user: @call.user, sid: @call.sid, to: @call.to, from: @call.from, call_status: @call.status)
      # User.last.twilio_incoming_logs.create(sid: @call.sid, to: @call.to, from: @call.from, call_status: @call.status)
      outgoing_log.create_twilio_incoming_log(user: outgoing_log.user, sid: @call.sid, to: @call.to, from: @call.from, call_status: @call.status)
    #   parent idをもとに検索してcreate
    else
      p "not create log"
    end

    # incomingLog = TwilioIncomingLog.find_by(dial_call_sid: params[:ParentCallSid])
    # User.last.twilio_outgoing_logs.create_log(incomingLog, twilio_outgoing_log_params)


    # incomingLog.create_twilio_outgoing_log(user: incomingLog.user)
    # incomingLog.create_log(incomingLog.user)
    # params[:ParentCallSid]
    # p "create_outgoing_log"
    p params
    render nothing: true
  end

  private

  def twilio_incoming_log_params
    params.permit(:CallSid, :To, :From, :DialCallStatus)
  end

  def twilio_outgoing_log_params
    params.permit(:CallSid, :ParentCallSid, :Timestamp, :To, :From, :CallStatus, :CallDuration)
  end
end
