class MessagesController < ApplicationController
  before_filter :must_be_sms

  def log(s)
    logger = Logger.new("/tmp/somelogs")
    logger.info(s)
    logger.flush
  end

  def index
   puts "testing puts"
   log "testing warn"
   log "In index"
    if params[:session][:parameters][:relay]
      log "session params relay is true"
      json = Message.json_for_relay(params[:session][:parameters])
      log "Relay response:"
      log json
      render :json => json
    else
      if user = User.find_by_phone_number(phone_number)
        @date = user.schedule_date_in(params[:session][:initialText])
        if @date.save
          render :json => date_response_message_for(user)
        else
          render :json => failed_to_save_date_message
        end
      else
        render :json => must_register_first_message
      end
    end
  end

  protected

  def must_be_sms
    network = params[:session].try(:[], :from).try(:[], :network)
    render :json => must_be_sms_message if network != 'SMS'
  end

  def date_response_message_for(user)
    if @date.scheduled?
      # Tell the user
      @user = user
      build_sms(render :action => 'date_complete')
      # Tell the date
      @user = @date.for(user)
      build_sms(render(:action => 'date_complete'), :to => @user.phone_number)
    else
      ### Also enqueue a follow-up 15m later
      build_sms(render :action => 'date_pending')
    end
  end

  def failed_to_save_date_message
    build_sms("Technical issue with making your date: #{@date.errors.full_messages.join(', ')}")
  end

  def must_register_first_message
    build_sms("You must register first at instalover.com")
  end

  def must_be_sms_message
    build_sms("Only phone texting is supported for now")
  end

  def phone_number
    params[:session].try(:[],:from).try(:[], :id)
  end

  def build_sms(s, opts = {})
    if opts[:to]
      Tropo::Generator.new do
        message :message => s, :to => "tel:+1#{opts[:to]}"
      end
    else
      Tropo::Generator.say(s)
    end
  end
end
