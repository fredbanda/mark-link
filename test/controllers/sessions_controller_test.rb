require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:jerry)
  end

  test "user is logged in and redirected to home with correct credentials" do
    assert_difference("@user.app_sessions.count", 1) {
      post login_path, params: {
        user: {
          email: "jerry@example.com", password: "jerrypassword"
           }
      }
    }
    assert_not_empty cookies[:app_session]
    assert_redirected_to root_path
end

test "user is not logged in and redirected to login with incorrect credentials" do
  post login_path, params: { user: {
    email: "jerry@example.com",
    password: "wrongpassword"
           }
      }
  assert_select ".notification",
  text: I18n.t("sessions.create.incorrect_details")
  end
end
