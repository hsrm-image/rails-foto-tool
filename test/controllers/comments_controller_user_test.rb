require "test_helper"

class CommentsControllerUserTest < ActionDispatch::IntegrationTest
  
  setup do
    @comment = comments(:userOne)
    @owner = users(:one)
    sign_in @owner
  end

  test "should create comment" do
    assert_difference('Comment.count', 1) do
      post image_comments_url(@comment.image), params: { comment: { text: @comment.text, username: @owner.name } }
    end

    assert_redirected_to image_url(@comment.image)
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      delete image_comment_url(@comment.image, @comment)
    end

    assert_redirected_to image_url(@comment.image)
  end

  test "should correct username if logged in" do
    assert_difference('Comment.count', 1) do
      post image_comments_url(@comment.image), params: { comment: { text: @comment.text, username: @owner.name + "_123" } }
    end

    assert_equal(@owner.name, Comment.last.username)

    assert_redirected_to image_url(@comment.image)
  end

  test "should not create comment without text" do
    assert_no_difference('Comment.count') do
      post image_comments_url(@comment.image), params: { comment: { text: "", username: @owner.name } }
    end
    assert_response(:unprocessable_entity)
  end

  test "should not create comment with too long text" do
    assert_no_difference('Comment.count') do
      post image_comments_url(@comment.image), params: { comment: { text: "A" * 50000, username: @owner.name } }
    end
    assert_response(:unprocessable_entity)
  end

  test "should not destroy comment from other user as normal user" do
    assert_no_difference('Comment.count') do
      delete image_comment_url(comments(:one).image, comments(:one)), headers: { "HTTP_REFERER": image_url(@comment.image) }
    end
    assert_redirected_to image_url(@comment.image)
  end

  test "should destroy comment from other user as admin" do
    @admin = users(:adminOne)
    sign_in @admin

    assert_difference('Comment.count', -1) do
      delete image_comment_url(@comment.image, @comment)
    end

    assert_redirected_to image_url(@comment.image)
  end
end
