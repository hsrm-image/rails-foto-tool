require "test_helper"

class UserFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @admin = users(:adminOne)
  end

  def log_in(user, password)
    get "/en/users/sign_in"
    assert_response :success
    post "/en/users/sign_in", params: { user: { email: user.email, password: password } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "signing in successfully" do 
    log_in(@user, "123456")
  end

  test "not signing in with wrong password" do 
    get "/en/users/sign_in"
    assert_response :success
    post "/en/users/sign_in", params: { user: { email: @user.email, password: "12345678" } }
    assert_response :ok
    assert_select "h2", I18n.t("devise.sessions.new.sign_in")
  end

  test "inviting new user" do
    log_in(@admin, "123456")
    get "/en/users/"
    assert_response :success
    get "/en/users/invitation/new"
    assert_response :success
    assert_no_difference "User.where(admin: true).count" do
      assert_difference "User.count", 1 do
        post "/en/users/invitation", params: { user: { email: @user.email+ "1", admin: "0" } }
      end
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "inviting new admin" do
    log_in(@admin, "123456")
    get "/en/users/"
    assert_response :success
    get "/en/users/invitation/new"
    assert_response :success
    assert_difference "User.where(admin: true).count", 1 do
      assert_difference "User.count", 1 do
        post "/en/users/invitation", params: { user: { email: @user.email+ "1", admin: "1" } }
      end
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "deleting user" do
    log_in(@admin, "123456")
    get "/en/users/"
    assert_response :success
    get "/en/users/" + users(:one).id.to_s
    assert_response :success
    assert_difference "User.count", -1 do
      delete "/en/users/" + users(:one).id.to_s
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "p", I18n.t("controllers.destroyed", resource: I18n.t("users.resource_name"))
  end

end
