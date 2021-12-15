require "test_helper"


class CommentsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  setup do
    @comment = comments(:one)
    @image = images(:one)
    puts(@image.id)
  end

  test "should create comment" do
    assert_difference('Comment.count') do
      post :create, params: { comment: { text: @comment.text, username: @comment.username }, image_id: @image.id}
    end

    assert_redirected_to comment_url(Comment.last)
  end

  test "should show comment" do
    get comment_url(@comment)
    assert_response :success
  end

  test "should get edit" do
    get edit_comment_url(@comment)
    assert_response :success
  end

  test "should update comment" do
    patch comment_url(@comment), params: { comment: { text: @comment.text, username: @comment.username } }
    assert_redirected_to comment_url(@comment)
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      delete comment_url(@comment)
    end

    assert_redirected_to comments_url
  end
end
