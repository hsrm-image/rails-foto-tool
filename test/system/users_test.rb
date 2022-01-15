require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @admin = users(:adminOne)
  end

  test "signing in correctly" do
    visit new_user_session_path
    assert_current_path(/sign_in/)

    fill_in "user_email", with: @user.email
    fill_in "user_password", with: 123456

    click_on I18n.t("devise.sessions.new.sign_in")
    assert_text I18n.t("devise.sessions.signed_in")
  end

  test "signing in with wrong password" do
    visit new_user_session_path
    assert_current_path(/sign_in/)

    fill_in "user_email", with: @user.email
    fill_in "user_password", with: "WRONG PW"

    click_on I18n.t("devise.sessions.new.sign_in")
    
    assert_text I18n.t("devise.failure.invalid", authentication_keys: "Email")
    assert_current_path(/sign_in/)
  end

  test "visiting the index as visitor" do
    visit users_url
    assert_text I18n.t("devise.failure.unauthenticated")
    assert_current_path(/sign_in/)
  end

  test "visiting the index as normal user" do
    sign_in(@user)
    visit users_url
    assert_text I18n.t("controllers.permission_denied")
  end

  test "visiting the index as admin" do
    sign_in(@admin)
    visit users_url
    assert_current_path(/users/)
  end

  test "making user admin" do
    sign_in(@admin)
    visit users_url
    page.all(:link, I18n.t("users.index.show")).last.click
    assert_difference "User.where(admin: true).count", 1 do
      accept_confirm do
        click_on I18n.t("users.show.change")
      end
      assert_selector(".admin_true", visible: true)
    end
  end

  test "inviting a new normal user" do
    sign_in(@admin)
    visit users_url
    click_on I18n.t("users.index.invite")
    fill_in "user_email", with: @user.email + "1" # E-Mails are unique in DB
    uncheck "user_admin"

    
    assert_no_difference "User.where(admin: true).count" do
      assert_difference "User.count", 1 do
        click_on I18n.t("devise.invitations.new.submit_button")
        assert_text(I18n.t("devise.invitations.send_instructions", email: @user.email + "1"))
      end
    end

    mail = ActionMailer::Base.deliveries.last
    assert_equal @user.email + "1", mail['to'].to_s
  end

  test "inviting a new admin" do
    sign_in(@admin)
    visit users_url
    click_on I18n.t("users.index.invite")
    fill_in "user_email", with: @user.email + "1" # E-Mails are unique in DB
    check "user_admin"

    
    assert_difference  "User.where(admin: true).count", 1 do
      assert_difference "User.count", 1 do
        click_on I18n.t("devise.invitations.new.submit_button")
        assert_text(I18n.t("devise.invitations.send_instructions", email: @user.email + "1"))
      end
    end

    mail = ActionMailer::Base.deliveries.last
    assert_equal @user.email + "1", mail['to'].to_s
  end

  test "deleting own account" do
    sign_in(@user)
    visit images_url
    first('.dropbtn').hover
    click_on I18n.t("application.account")

    
    assert_difference "User.count", -1 do
      accept_confirm do
        click_on I18n.t("devise.registrations.edit.cancel_my_account")
      end
      sleep(1)
    end

    assert(!User.exists?(@user.id))
  end
end
