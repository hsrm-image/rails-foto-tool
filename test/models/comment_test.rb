require "test_helper"

class CommentTest < ActiveSupport::TestCase
  setup do
    @comment = comments(:one)
  end

  test "should correct username if userid present" do
    @comment.username = "#{users(:one).name} abc"
    @comment.user_id = users(:one).id

    @comment.correct_name
    @comment.save!

    assert_equal users(:one).name, @comment.username
  end

  test "should not correct username without userid" do
    @comment.username = "#{users(:one).name} abc"
    @comment.user_id = nil

    @comment.correct_name
    @comment.save!

    assert_equal "#{users(:one).name} abc", @comment.username
  end
end
