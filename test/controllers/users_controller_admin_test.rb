require "test_helper"

class UsersControllerAdminTest < ActionDispatch::IntegrationTest
  setup do
		@user = users(:adminOne)
		sign_in @user
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should make user admin" do
    other_user = users(:one)
    assert !User.find(other_user.id).admin

    patch admin_user_url(other_user)
    assert_redirected_to user_url(other_user)

    assert User.find(other_user.id).admin
  end

  test "should revoke user admin" do
    other_user = users(:adminTwo)
    assert User.find(other_user.id).admin

    patch admin_user_url(other_user)
    assert_redirected_to user_url(other_user)

    assert !User.find(other_user.id).admin
  end

  test "should not revoke last admin" do
    User.all.each do |usr|
      usr.admin = false unless usr == @user
      usr.save!
    end

    assert_equal 1, User.where(admin: true).count
    assert_no_difference "User.where(admin: true).count" do
      patch admin_user_url(@user)
    end
  end

  test "should not edit own permissions" do
    assert_no_difference "User.where(admin: true).count" do
      patch admin_user_url(@user)
    end
  end
end
