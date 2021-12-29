require "test_helper"

class RatingsControllerTestImages < ActionDispatch::IntegrationTest
  setup do
    @rating = ratings(:imageOne)
  end

  test "should create rating" do
    assert_difference('Rating.count', 1) do
      post ratings_url, params: { rating: { rating: @rating.rating, rateable_id: @rating.rateable_id, rateable_type: @rating.rateable_type } }, headers: { "HTTP_REFERER": image_url(@rating.rateable_id) }
    end

    assert_redirected_to image_url(@rating.rateable_id)
  end

  test "should update rating" do
    post ratings_url, params: { rating: { rating: 5, rateable_id: @rating.rateable_id, rateable_type: @rating.rateable_type } }, headers: { "HTTP_REFERER": image_url(@rating.rateable_id) }
    assert_equal(5, Rating.last.rating)
    assert_no_difference('Comment.count') do
      post ratings_url, params: { rating: { rating: 1, rateable_id: @rating.rateable_id, rateable_type: @rating.rateable_type } }, headers: { "HTTP_REFERER": image_url(@rating.rateable_id) }
      assert_equal(1, Rating.last.rating)
    end

    assert_redirected_to image_url(@rating.rateable_id)
  end

  #test "should destroy rating" do
    #assert_difference('Rating.count', -1) do
      #delete rating_url(@rating)
    #end

    #assert_redirected_to ratings_url
  #end
end
