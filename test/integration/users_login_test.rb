require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?   # true:NG false:OK
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0   # loginはない
    assert_select "a[href=?]", logout_path    # logoutはある
    assert_select "a[href=?]", user_path(@user)    # profileがある
    delete logout_path
    assert_not is_logged_in?    # true:NG false:OK
    assert_redirected_to root_url
    # 2番目のウインドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path                     # loginある
    assert_select "a[href=?]", logout_path,       count: 0    # logoutはない
    assert_select "a[href=?]", user_path(@user),  count: 0    # profileがない
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end

end
