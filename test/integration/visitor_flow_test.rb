require "test_helper"

class VisitorFlowTest < ActionDispatch::IntegrationTest
  setup do
    @image = images(:one)
    @rating = ratings(:imageOne)
  end

  test "visiting an image and rating it" do
    get "/en/images"
    assert_response :success

    get "/en/images/#{@image.id}"
    assert_response :success
    assert_select "h1#image-title", @image.title

    assert_difference "Rating.where(rateable_id: #{@image.id}, rateable_type: 'Image').count", 1 do
        post "/en/ratings", params: { rating: { rating: 1, rateable_id: @image.id, rateable_type: "Image" } }, as: :json
    end
    assert_response :ok
  end

  # For more thorough tests please check the system tests.
end