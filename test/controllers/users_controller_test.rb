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

  test "renders errors if input data is invalid" do
    get sign_up_path
    assert_response :ok

    assert_no_difference ["User.count", "Organization.count"] do
      post sign_up_path, params: {
         user: { 
          name: "Fred Banda", 
          email: "testuser@example.com", 
          password: "1234" 
          } 
        }
    end

    assert_response :unprocessable_entity
    assert_select "p.is-danger", 
    text: 
    I18n.t
    ("activerecord.errors.models.user.attributes.password.too_short")
  end
end
