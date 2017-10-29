require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    remember(@user)
  end

  # current_userが渡されたユーザーと同じであることを確認
  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  # ユーザーの記憶ダイジェストが記憶トークンと正しく対応していない場合は現在のユーザーがnilになる
  test "current_user returns nill when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end