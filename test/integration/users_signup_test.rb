require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  # ActionMailer::Base.deliveriesという配列を初期化
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: {name: "",
                              screen_name: "",
                              email: "user@invalid",
                              password: "foo",
                              password_confirmation: "bar"}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path users_path, user: {name: "Example User",
                                         screen_name: "example",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "password"}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?    # true:NG false:OK
    # 有効化していない状態でログインしてみる
    log_in_as(user)
    assert_not is_logged_in?      # true:NG false:OK
    # 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

end
