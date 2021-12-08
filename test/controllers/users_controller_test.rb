require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post user_registration_url, params: { user: { password_confirmation: "123456", name: @user.name, email: "p@a.de", password: "123456" } }
      #puts "#{response.inspect}"
    end

    assert_redirected_to root_path
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { admin: @user.admin, name: @user.name } }
    assert_redirected_to user_url(@user)
  end


end
