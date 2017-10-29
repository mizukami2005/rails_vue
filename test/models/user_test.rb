require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", screen_name: "example", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?   # true:OK false:NG
  end

  test "name should be present" do
    @user.name = " "    # 名前に空白の文字列セットしたらオブジェクトは有効でなくなるよね
    assert_not @user.valid?   # true:NG false:OK
  end

  test "screen_name should be present" do
    @user.screen_name = " "
    assert_not @user.valid?
  end

  test "screen_name should not br too long" do
    @user.screen_name = "a" * 26
    assert_not @user.valid? # true:NG false:OK
  end

  test "screen_name validatoin should accept valid screen_name" do
    valid_screen_names = %w[user USER A_US firST example_michael]
    valid_screen_names.each do |valid_screen_name|
      @user.screen_name = valid_screen_name
      assert @user.valid?, "#{valid_screen_name.inspect} should be valid"
    end
  end

  test "screen_name validation should reject invalid screen_name" do
    valid_screen_names = %w[~user u!ser us@er user# $user u%ser us^er use&r
                          user* (user u)ser us-er user+ =user us{er use}r user|
                          \user u<ser us>er use,r user. ?user u/ser]
    valid_screen_names.each do |invalid_screen_name|
      @user.screen_name = invalid_screen_name
      assert_not @user.valid?, "#{invalid_screen_name.inspect} should be invalid" # true:NG false:OK
    end
  end

  test "screen_name should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid? # true:NG false:OK
  end

  test "email should be present" do
    @user.email = " "    # メールアドレスに空白の文字列セットしたらオブジェクトは有効でなくなるよね
    assert_not @user.valid?   # true:NG false:OK
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?   # true:NG false:OK
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"    # メールに256文字数いれたオブジェクトは有効でなくなるよね
    assert_not @user.valid?   # true:NG false:OK
  end

  test "email validatoin should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"   # true:NG false:OK
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?    # true:NG false:OK
  end

  # 空文字6つだとエラーだよね
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?   # true:NG false:OK
  end

  # 5文字だとエラーになるよね
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?   # true:NG false:OK
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test "feed should have the right posts" do
    michael = users(:michael)
    archer = users(:archer)
    lana = users(:lana)
    mark = users(:mark)
    # フォローしているユーザーの投稿を確認
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # 自分自身の投稿を確認
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end

    # フォローしていないユーザーの投稿を確認
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end

    # 返信された受信者の投稿を確認
    lana.microposts.each do |reply_to_mark|
      assert mark.feed.include?(reply_to_mark)
    end

    # 返信された受信者にのみ投稿を確認
    lana.microposts.each do |reply_to_mark|
      assert_not archer.feed.include?(reply_to_mark)
    end
  end
end
