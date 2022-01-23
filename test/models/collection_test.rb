require "test_helper"

class CollectionTest < ActiveSupport::TestCase

  setup do
    @collection = new_collection
  end


  def random_rate_collection(collection, n=10)
    ratings = []
    score = 0.0
    n.times do |x|
      rating = Rating.new()
      rating.rateable = collection
      rating.rating = rand(1..5)
      rating.session_id = SecureRandom.hex(16)
      rating.save!

      ratings << rating
      score += rating.rating
    end
    score /= ratings.count

    return ratings, score
  end

  def new_collection
    collection = Collection.new()
    collection.owner = collections(:one).owner
    collection.name = collections(:one).name
    collection.save!
    return collection
  end

  test "should get ratings for collection" do
    ratings, score = random_rate_collection(@collection, 10)

    assert_not_nil @collection.get_ratings
    assert_equal ratings, @collection.get_ratings
  end
  
  test "should get total score for collection" do
    ratings, score = random_rate_collection(@collection, 10)

    assert_equal score, @collection.get_score
  end

  test "should get rate for one user" do
    ratings, score = random_rate_collection(@collection, 10)
    rate = ratings.sample

    assert @collection.has_rated?(rate.session_id)
    assert !@collection.has_rated?(SecureRandom.hex(16))

    assert_equal rate, @collection.get_rate(rate.session_id)
    assert_nil @collection.get_rate(SecureRandom.hex(16))
  end
end
