require "test_helper"

class ImageTest < ActiveSupport::TestCase
  setup do
    @image = images(:one)
  end

  test "should get ratings for image" do
    assert_equal Rating.where(rateable_id: @image.id, rateable_type: "Image"), @image.get_ratings
  end

  test "should get score for image" do
    sum = 0
    @image.get_ratings.each{ |x| sum += x.rating }
    rating = 1.0 * sum / @image.get_ratings.count
    assert_equal @image.get_score, rating
  end
  
end
