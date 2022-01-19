require 'test_helper'

class CommentsControllerVisitorTest < ActionDispatch::IntegrationTest
	setup { @comment = comments(:one) }

	test 'should not create comment without text' do
		assert_no_difference('Comment.count') do
			post image_comments_url(@comment.image),
			     params: {
					comment: {
						text: '',
						username: @comment.username,
					},
			     }
		end
		assert_response(:unprocessable_entity)
	end

	test 'should not create comment with too long text' do
		assert_no_difference('Comment.count') do
			post image_comments_url(@comment.image),
			     params: {
					comment: {
						text: 'A' * 50_000,
						username: @comment.username,
					},
			     }
		end
		assert_response(:unprocessable_entity)
	end

	test 'should not create comment with too long username' do
		assert_no_difference('Comment.count') do
			post image_comments_url(@comment.image),
			     params: {
					comment: {
						text: @comment.text,
						username: 'A' * 50_000,
					},
			     }
		end
		assert_response(:unprocessable_entity)
	end

	test 'should not destroy comment from other user' do
		assert_no_difference('Comment.count') do
			delete image_comment_url(comments(:two).image, comments(:two)),
			       headers: {
					'HTTP_REFERER': image_url(@comment.image),
			       }
		end
		assert_redirected_to image_url(@comment.image)
	end

end
