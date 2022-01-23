require "application_system_test_case"

class RatingsCollectionTest < ApplicationSystemTestCase
  setup do
    @rating = ratings(:collectionOne)
    @collection = collections(:one)
    perform_enqueued_jobs
  end

  test "creating a rating on a collection" do
    visit collections_url
    page.all('.grid-element').last.click

    assert_difference "Rating.count", 1 do
      assert_difference "Rating.where(rateable_type: 'Collection').count", 1 do
        find("#star_#{@rating.rating}").click
        (1..5).each do |n|
          assert_selector("#star_#{n}" + ( n <= @rating.rating ? ".bi-star-fill" : ".bi-star"), wait: 1)
        end
      end
    end

    assert_equal Rating.last.rating, @rating.rating
  end

  test "updating a rating on a collection" do
    assert @rating.rating > 1, "Please select a rating greater than 1 for this test"
    visit collections_url
    page.all('.grid-element').last.click
    
    assert_difference "Rating.count", 1 do
      assert_difference "Rating.where(rateable_type: 'Collection').count", 1 do
        find("#star_#{@rating.rating-1}").click
        assert_selector "#star_#{@rating.rating-1}.bi-star-fill", wait: 1 # This is just to give the database some time to update
      end
    end

    assert_no_difference "Rating.count" do
      find("#star_#{@rating.rating}").click
      assert_selector "#star_#{@rating.rating-1}.bi-star-fill", wait: 1 # This is just to give the database some time to update
    end

    assert_equal Rating.last.rating, @rating.rating
  end

  test "no rating without session cookie" do
    visit collections_url
    Capybara.current_session.driver.browser.manage.delete_all_cookies
    page.all('.grid-element').last.click

    assert_text I18n.t("ratings.interface.no_session")
    assert_no_selector "#star_1"
  end
end
