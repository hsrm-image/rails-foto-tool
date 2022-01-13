require 'test_helper'

class ImagesControllerTestVisitor < ActionDispatch::IntegrationTest
	setup { @image = images(:one) }

	test 'should get index' do
		get images_url
		assert_response :success
	end

	test 'should not get new' do
		get new_image_url
		assert_redirected_to root_url
	end

	test 'should not create image' do
		file =
			fixture_file_upload(
				Rails.root.join('test', 'fixtures', 'files', 'test.png'),
				'image/png',
			)
		assert_no_difference('ActiveStorage::Attachment.count') do
			assert_no_difference('Image.count') do
				post images_url,
				     params: {
						image: {
							description: @image.description,
							title: @image.title,
							image_file: file,
						},
				     }
			end
		end

		assert_redirected_to root_url
	end

	test 'should show processed image' do
		get image_url(@image)
		assert_response :success
	end

	test 'should not show processing image' do
		@image = images(:processing)
		get image_url(@image)
		assert_redirected_to images_url
	end

	test 'should not get edit' do
		get edit_image_url(@image)
		assert_redirected_to root_url
	end

	test 'should not update image' do
		patch image_url(@image),
		      params: {
				image: {
					description: @image.description,
					title: @image.title,
				},
		      }
		assert_redirected_to root_url
	end

	test 'should not destroy image' do
		assert_no_difference('ActiveStorage::Attachment.count') do
			assert_no_difference('Image.count') { delete image_url(@image) }
		end

		assert_redirected_to root_url
	end
end
