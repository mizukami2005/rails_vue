class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost   = current_user.microposts.build
      # @feed_items = current_user.feed.paginate(page: params[:page])
      @feed_items  = Micropost.includes(:user).paginate(page: params[:page])
      gon.micropost_count = Micropost.count
    end
  end

  def twellio
    p "twilio"
    p params
    p "CallDuration"
    p params[:CallDuration]
  end

  def help
  end

  def about
  end

  def contact
  end
end
