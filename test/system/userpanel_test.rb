require "application_system_test_case"

class UserpanelTest < ApplicationSystemTestCase
  setup do
    perform_enqueued_jobs
    @user = users(:one)
    sign_in(@user)
  end

  test "visiting the index as visitor" do
    sign_out(@user)
    visit userpanel_url
    assert_text I18n.t("devise.failure.unauthenticated")
  end

  test "visiting the index when signed in" do
    visit userpanel_url
    assert_selector "h3", text: "categories"
  end
end
