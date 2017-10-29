require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @other = users(:archer)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
    @no_save_user = User.new(name: "Not Found User", screen_name: "not_found_user", email: "not_found_user@example.com",
                             password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

  test "reply_to_user_id should be present when content include @screen_name" do
    @micropost.content = "@#{@user.screen_name} Hello"
    @micropost.save
    @micropost.reload
    assert_equal @user.id, @micropost.reply_to_user_id
  end

  test "reply_to_user_id should be not present when not found user" do
    @micropost.content = "@#{@no_save_user.screen_name} Hello"
    @micropost.save
    @micropost.reload
    assert_nil @micropost.reply_to_user_id
  end

  test "reply_to_user_id has only one user" do
    @micropost.content = "@#{@user.screen_name} @#{@other.screen_name} Hello"
    @micropost.save
    @micropost.reload
    assert_equal @user.id, @micropost.reply_to_user_id
  end

end
