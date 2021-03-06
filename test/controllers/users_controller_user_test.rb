require "test_helper"

class UsersControllerUserTest < ActionDispatch::IntegrationTest
  setup do
		@user = users(:one)
		sign_in @user
  end

  test "should not get index" do
    get users_url
    assert_redirected_to root_url
  end

  test "should not show user" do
    get user_url(@user)
    assert_redirected_to root_url
  end

  test "should not make user admin" do
    other_user = users(:two)
    assert !User.find(other_user.id).admin

    patch admin_user_url(other_user)
    assert_redirected_to root_url

    assert !User.find(other_user.id).admin
  end

  test "should not edit own permissions" do
    assert_no_difference "User.where(admin: true).count" do
      patch admin_user_url(@user)
    end
  end
end
