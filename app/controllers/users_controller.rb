class UsersController < ApplicationController
  # ユーザー一覧,編集,更新,削除を行う時にはログイン済みであるかどうかを確認する
  # before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
  #                                     :following, :followers]
  # 編集,更新を行う時には正しいユーザーであるかどうかを確認する
  skip_before_action :verify_authenticity_token
  before_action :correct_user, only: [:edit, :update]
  # 削除を行うときには管理者かどうか確認する
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
    gon.users = User.all
    # @client = Twilio::REST::Client.new
    # @client.calls.list
    #   .each do |call|
    #   puts call.duration
    #   puts call.to
    # end
    # render nothing: true
    # response = Twilio::TwiML::VoiceResponse.new
    # response.dial(caller_id: '+815031886593') do |dial|
    #   dial.number('+818016015579')
    # end
    # # response.say('Hello World')
    # # response.record(action: 'https://0606224c.ngrok.io/users', method: 'POST',
    # #                 max_length: 20)
    # render xml: response.to_s
  end

  def new
    @user = User.new
    # account_sid = 'AC31921c354856a6484fedca68a8d6d9f1'
    # auth_token = 'f702269f50e15cd35225087946306c08'
    # @client = Twilio::REST::Client.new
    # @client.api.account.calls.create(
    #   from: '+815031889838',
    #   to: '+818016015579',
    #   url: users_url,
    #   method: 'GET'
    # )
    # redirect_to root_path
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  # 新規ユーザーの作成
  # 新規ユーザーの登録後,ユーザー有効化メールを送信
  def create
    p 'create'
    p params
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:success] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      # 更新に成功した時の処理
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def add
    if session[:facility_ids].blank?
      p "空ですよ"
      session[:facility_ids] = []
      session[:facility_ids] << params[:id]
      p session
    else
      p "すでにあります"
      unless session[:facility_ids].include?(params[:id])
        session[:facility_ids] << params[:id]
      end
      p session
      # session[:facility_ids] = nil
    end
    redirect_to users_url
  end

  def add_user
    if session[:users_ids].blank?
      p "空ですよ"
      session[:users_ids] = []
      session[:users_ids] << params[:id].to_i
      p session
    else
      p "すでにあります"
      unless session[:users_ids].include?(params[:id])
        session[:users_ids] << params[:id].to_i
      end
      p session
      # session[:facility_ids] = nil
    end
    # redirect_to user_path(params[:id])
    @user = User.find(params[:id])
    # ログインしていたらフォローする
    current_user.follow(@user) if logged_in?

    respond_to do |format|
      format.html { redirect_to user_path(params[:id]) }
      format.js
    end
  end

  def delete_user
    @user = User.find(params[:id])
    # ログインしていたらアンフォローする
    unfollow_user = Relationship.find_by(followed_id: params[:id]).try(:followed) if logged_in?
    current_user.unfollow(unfollow_user) if logged_in? && unfollow_user.present?
    session[:users_ids].delete(params[:id].to_i)
    respond_to do |format|
      format.html { redirect_to user_path(params[:id]) }
      format.js
    end
    # redirect_to user_path(params[:id])
  end

  # # フォロー
  # def create
  #   @user = User.find(params[:followed_id])
  #   current_user.follow(@user)
  #   respond_to do |format|
  #     format.html { redirect_to @user }
  #     format.js
  #   end
  # end
  #
  # # アンフォロー
  # def destroy
  #   @user = Relationship.find(params[:id]).followed
  #   current_user.unfollow(@user)
  #   respond_to do |format|
  #     format.html { redirect_to @user }
  #     format.js
  #   end
  # end

  private

    def user_params
      params.require(:user).permit(:name, :screen_name, :email, :password,
                                   :password_confirmation)
    end

    # beforeフィルター

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
