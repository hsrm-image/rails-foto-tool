require "test_helper"

class ImageTest < ActiveSupport::TestCase
  setup do
    @image = images(:one)
  end

  def new_image
    image = Image.new()
    image.image_file = images(:one).image_file.blob
    image.owner = images(:one).owner
    image.save!
    return image
  end

  def random_rate_image(image, n=10)
    ratings = []
    score = 0.0
    n.times do |x|
      rating = Rating.new()
      rating.rateable = image
      rating.rating = rand(1..5)
      rating.session_id = SecureRandom.hex(16)
      rating.save!

      ratings << rating
      score += rating.rating
    end
    score /= ratings.count

    return ratings, score
  end

  test "should get ratings for image" do
    @image = new_image
    ratings, score = random_rate_image(@image, 10)

    assert_not_nil @image.get_ratings
    assert_equal ratings, @image.get_ratings
  end
  
  test "should get total score for image" do
    @image = new_image
    ratings, score = random_rate_image(@image, 10)

    assert_equal score, @image.get_score
  end

  test "should get rate for one user" do
    @image = new_image
    ratings, score = random_rate_image(@image, 10)
    rate = ratings.sample

    assert @image.has_rated?(rate.session_id)
    assert !@image.has_rated?(SecureRandom.hex(16))

    assert_equal rate, @image.get_rate(rate.session_id)
    assert_nil @image.get_rate(SecureRandom.hex(16))
  end

  test "should skip not processed images as visitor" do
    images.each do |img|
      assert_not_equal img.next(nil), images(:processing)
      assert_not_equal img.previous(nil), images(:processing)
    end
  end

  test "should navigate to all images as user" do
    nexts = []
    prevs = []
    images.each do |img|
      nexts << img.next(true)
      prevs << img.previous(true)
    end

    assert_includes nexts, images(:processing)
    assert_includes prevs, images(:processing)
  end
end
