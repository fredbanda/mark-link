require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "redirects to feed after successful sign up" do
    get sign_up_path
    assert_response :success

    assert_difference([ "User.count", "Organization.count" ], 1) do
      post sign_up_path, params: { user: {
        name: "Test User",
        email: "testuser@example.com",
        password: "testpassword123",
        password_confirmation: "testpassword123"
      } }
    end

    # Check flash message directly
    assert_equal I18n.t("users.create.welcome", name: "Test User"), flash[:success]
    assert_redirected_to root_path
    assert_not_empty cookies[:app_session]

    # Follow redirect and check if notification appears in view
    follow_redirect!
    assert_select ".notification.is-success", text: I18n.t("users.create.welcome", name: "Test User")
  end

  test "does not sign_up if password confirmation does not match" do
    get sign_up_path
    assert_response :success

    assert_no_difference([ "User.count", "Organization.count" ]) do
      post sign_up_path, params: { user: {
        name: "Test User",
        email: "testuser@example.com",
        password: "testpassword123",
        password_confirmation: "testpassword"
      } }
      end
      assert_response :unprocessable_entity
    end

    test "can create session with a correct email and password" do
      # Create the user before testing login
      user = User.create!(
        name: "Test User",
        email: "testuser@example.com",
        password: "testpassword123",
        password_confirmation: "testpassword123"
      )

      puts "✅ User created: #{user.inspect}"  # Debugging line

      # Attempt to create session
      @app_session = User.create_app_session(
        email: "testuser@example.com",
        password: "testpassword123"
      )

      puts "🛠️ Debug: @app_session => #{@app_session.inspect}"  # Debugging line

      # Assertions
      assert_not_nil @app_session, "❌ Expected @app_session to be present, but it's nil!"
      assert_not_nil @app_session.token, "❌ Expected @app_session.token to be present, but it's nil!"
    end



    test "can not create session with a correct email and incorrect password" do
      @app_session = User.create_app_session(email: "jerry@example.com", password: "wrong")

      assert_nil @app_session
    end
    test "creating a session with a non existing email returns nil" do
      @pp_session = User.create_app_session(email: "non-existing@example.com", password: "wrong")

      assert_nil @pp_session
    end
end
