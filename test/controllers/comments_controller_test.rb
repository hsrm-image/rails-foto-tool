require "test_helper"


class CommentsControllerTest < ActionDispatch::IntegrationTest
  
  setup do
    @comment = comments(:one)
  end

  test "should create comment" do
    assert_difference('Comment.count') do
      post image_comments_url(@comment.image), params: { comment: { text: @comment.text, username: @comment.username, session_id: "abcDiesIstEineSession123" } }
    end

    assert_redirected_to image_url(@comment.image)
  end

  # Does not work because session cant be changed in tests...
  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      delete image_comment_url(@comment.image, @comment), params: {comment: {session_id: "abcDiesIstEineSession123"}}
    end

    assert_redirected_to comments_url
  end
end
