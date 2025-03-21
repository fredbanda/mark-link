require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "requires a name" do
      @user = User.new(name: "", email: "fred@example.com", password: "password123")
      assert_not @user.valid?
      puts @user.errors.full_messages # Debugging output

      @user.name = "Fred"
      assert @user.valid?, @user.errors.full_messages.join(", ") # More debugging output
    end

  test "requires a valid email" do
    @user = User.new(name: "Fred", email: "", password: "password123")
    assert_not @user.valid?

    @user.email = "fred@@example."
    assert_not @user.valid?

    @user.email = "fred@example.com"
    assert @user.valid?
  end

  test "requires a unique email" do
    @existing_user = User.create(name: "John", email: "fredo@example.com", password: "password123")
    assert @existing_user.persisted?

    @user = User.new(name: "Jane", email: "fredo@example.com", password: "password123")
    assert_not @user.valid?
  end

  test "name and email is stripped of whitespaces before saving" do
    @user = User.create(name: " Fred ", email: " fred@example.com ")
    assert_equal "Fred", @user.name
    assert_equal "fred@example.com", @user.email
  end

  test "password length must be between 8 and ActiveModel's maximum" do
    @user = User.create(name: "Fred", email: "fred@example.com", password: "")
    assert_not @user.valid?

    @user.password = "password"
    assert @user.valid?

    max_length = ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
    @user.password = "a" * (max_length + 1)
    assert_not @user.valid?
  end

  test "can authenticate with a valid session id and token" do
    @user = users(:jerry)
    @app_session = @user.app_sessions.create

    assert_equal @app_session,
    @user.authenticate_app_session(@app_session.id, @app_session.token)
  end

  test "trying to authenticate with a token that does not match returns false" do
    @user = users(:jerry)

    assert_not @user.authenticate_app_session(50, "token")
  end
end
