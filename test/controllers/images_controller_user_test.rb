require 'test_helper'

class ImagesControllerUserTest < ActionDispatch::IntegrationTest
	setup do
		@image = images(:one)
		@owner = users(:one)
		sign_in @owner
	end

	test 'should get index' do
		get images_url
		assert_response :success
	end

	test 'should get new' do
		get new_image_url
		assert_response :success
	end

	test 'should create image' do
		file =
			fixture_file_upload(
				Rails.root.join('test', 'fixtures', 'files', 'test.png'),
				'image/png',
			)
		assert_difference('ActiveStorage::Attachment.count', 1) do
			assert_difference('Image.count', 1) do
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

		assert_redirected_to image_url(Image.last)
	end

	test 'should show processed image' do
		get image_url(@image)
		assert_response :success
	end

	test 'should show processing image' do
		@image = images(:processing)
		get image_url(@image)
		assert_response :success
	end

	test 'should get own edit' do
		get edit_image_url(@image)
		assert_response :success
	end

	test 'should update own image' do
		patch image_url(@image),
		      params: {
				image: {
					description: @image.description + "abc",
					title: @image.title + "def",
				},
			  }
		assert_response :success
		assert_equal Image.find(@image.id).description, @image.description + "abc"
		assert_equal Image.find(@image.id).title, @image.title + "def"

	end

	test 'should destroy own image' do
		assert_difference('ActiveStorage::Attachment.count', -1) do
			assert_difference('Image.count', -1) { delete image_url(@image), xhr: true, as: :js }
		end

		assert_response :success
	end
end
