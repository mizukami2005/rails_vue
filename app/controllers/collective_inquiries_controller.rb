class CollectiveInquiriesController < ApplicationController

  def index
  end

  def new
    if logged_in?
      @users = User.where(id: (current_user.following_ids + session[:users_ids].to_a).uniq)
    else
      @users = User.where(id: session[:users_ids])
    end

    @micropost = Micropost.new
  end

  def create
    count = 0
    ActiveRecord::Base.transaction do
      micropost_params[:user_id].each do |user_id|
        @micropost = Micropost.new(micropost_params)
        @micropost.user_id = user_id
        @micropost.save
        count += 1
      end
      flash[:success] = "#{count}件の問い合わせが完了しました"
      redirect_to root_url
    end
      render 'new'
    rescue => e
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture, :reply_to_user_id, user_id: [])
    end

    # def correct_user
    #   @micropost = current_user.microposts.find_by(id: params[:id])
    #   redirect_to root_url if @micropost.nil?
    # end
end
