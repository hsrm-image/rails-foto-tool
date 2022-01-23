require "test_helper"

class ImageTest < ActiveSupport::TestCase
  setup do
    @image = images(:one)
    @image2 = images(:two)
    @image3 = images(:three)
    @processing = images(:processing)

    @collection = collections(:two)
  end

  def new_image
    image = Image.new()
    image.image_file = images(:one).image_file.blob
    image.owner = images(:one).owner
    image.title = images(:one).title
    image.description = images(:one).description
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
      assert_not_equal img.next(nil), @processing
      assert_not_equal img.previous(nil), @processing
    end
  end

  test "should navigate to all images as user" do
    nexts = []
    prevs = []
    images.each do |img|
      nexts << img.next(true)
      prevs << img.previous(true)
    end

    assert_includes nexts, @processing
    assert_includes prevs, @processing
  end

  test "should only navigate images in collection" do
    @collection.images << @image
    @collection.images << @image2

    nexts = []
    prevs = []

    @collection.images.each do |img|
      nexts << img.next(nil, @collection)
      prevs << img.previous(nil, @collection)
    end

    assert_includes nexts, @image
    assert_includes prevs, @image

    assert_includes nexts, @image2
    assert_includes prevs, @image2

    assert_not_includes nexts, @image3
    assert_not_includes prevs, @image3
  end

  test "should skip not processed images in collection as visitor" do
    @collection.images << @image
    @collection.images << @image2
    @collection.images << @processing

    @collection.images.each do |img|
      assert_not_equal img.next(nil), @processing
      assert_not_equal img.previous(nil), @processing
    end
  end

  test "should show all images in collection as user" do
    @collection.images << @image
    @collection.images << @image2
    @collection.images << @processing

    nexts = []
    prevs = []

    @collection.images.each do |img|
      nexts << img.next(true, @collection)
      prevs << img.previous(true, @collection)
    end

    assert_includes nexts, @processing
    assert_includes prevs, @processing
  end
end
