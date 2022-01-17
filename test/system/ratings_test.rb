require "application_system_test_case"

class RatingsTest < ApplicationSystemTestCase
  setup do
    @rating = ratings(:imageTwo)
    @image = images(:one)
    perform_enqueued_jobs
  end

  test "creating a rating" do
    Capybara.session_name = "first_session"
    visit images_url
    page.all('.grid-element').last.click

    assert_difference "Rating.count", 1 do
      find("#star_#{@rating.rating}").click
      (1..5).each do |n|
        assert_selector("#star_#{n}" + ( n <= @rating.rating ? ".bi-star-fill" : ".bi-star"), wait: 1)
      end
    end

    assert_equal Rating.last.rating, @rating.rating
  end

  test "updating a rating" do
    assert @rating.rating > 1, "Please select a rating greater than 1 for this test"
    visit images_url
    page.all('.grid-element').last.click
    
    assert_difference "Rating.count", 1 do
      find("#star_#{@rating.rating-1}").click
      assert_selector "#star_#{@rating.rating-1}.bi-star-fill", wait: 1 # This is just to give the database some time to update
    end

    assert_no_difference "Rating.count" do
      find("#star_#{@rating.rating}").click
      assert_selector "#star_#{@rating.rating-1}.bi-star-fill", wait: 1 # This is just to give the database some time to update
    end

    assert_equal Rating.last.rating, @rating.rating
  end

  test "no rating without session cookie" do
    visit images_url
    Capybara.current_session.driver.browser.manage.delete_all_cookies
    page.all('.grid-element').last.click

    assert_text I18n.t("ratings.interface.no_session")
    assert_no_selector "#star_1"
  end
end
