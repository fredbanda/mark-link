require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "redirects to feed after successful sign up" do
    get sign_up_path
    assert_response :success
  
    assert_difference(["User.count", "Organization.count"], 1) do
      post sign_up_path, params: { user: { 
        name: "Test User", 
        email: "testuser@example.com", 
        password: "testpassword123" 
      } }
    end
  
    # Check flash message directly
    assert_equal I18n.t("users.create.welcome", name: "Test User"), flash[:success]
  
    # Follow redirect and check if notification appears in view
    follow_redirect!
    assert_select ".notification.is-success", text: I18n.t("users.create.welcome", name: "Test User")
  end

  test "does not sign_up if password confirmation does not match" do
    get sign_up_path
    assert_response :success

    assert_no_difference(["User.count", "Organization.count"]) do
      post sign_up_path, params: { user: { 
        name: "Test User", 
        email: "testuser@example.com", 
        password: "testpassword123", 
        password_confirmation: "testpassword" 
      } }
      end
    end
  end