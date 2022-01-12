require "test_helper"

class RatingsControllerTestImages < ActionDispatch::IntegrationTest
  setup do
    @rating = ratings(:imageOne)
  end

  test "should create rating" do
    assert_difference('Rating.count', 1) do
      post ratings_url, params: { rating: { rating: @rating.rating, rateable_id: @rating.rateable_id, rateable_type: @rating.rateable_type } }, headers: { "HTTP_REFERER": image_url(@rating.rateable_id) }, as: :json
    end

    assert_equal @rating.rateable.get_ratings.count, @response.parsed_body["nr_ratings"]
    assert_equal @rating.rateable.get_score, @response.parsed_body["rating"]
  end

  test "should update rating" do
    post ratings_url, params: { rating: { rating: 5, rateable_id: @rating.rateable_id, rateable_type: @rating.rateable_type } }, headers: { "HTTP_REFERER": image_url(@rating.rateable_id) }, as: :json
    assert_equal(5, Rating.last.rating)
    assert_no_difference('Rating.count') do
      post ratings_url, params: { rating: { rating: 1, rateable_id: @rating.rateable_id, rateable_type: @rating.rateable_type } }, headers: { "HTTP_REFERER": image_url(@rating.rateable_id) }, as: :json
      assert_equal(1, Rating.last.rating)
    end

    assert_equal @rating.rateable.get_ratings.count, @response.parsed_body["nr_ratings"]
    assert_equal @rating.rateable.get_score, @response.parsed_body["rating"]
  end

  #test "should destroy rating" do
    #assert_difference('Rating.count', -1) do
      #delete rating_url(@rating)
    #end

    #assert_redirected_to ratings_url
  #end
end
