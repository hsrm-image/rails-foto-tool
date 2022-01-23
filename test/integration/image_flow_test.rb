require "test_helper"

class ImageFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @image = images(:one)
    @collection = collections(:one)
  end

  def log_in(user, password)
    get "/en/users/sign_in"
    assert_response :success
    post "/en/users/sign_in", params: { user: { email: user.email, password: password } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "uploading an new Image" do
    log_in(@user, "123456")
    get "/en/userpanel"
    assert_response :success

    get "/en/userpanel/show_images", xhr: true, as: :js
    assert_response :success

    assert_equal @response.body.scan("widget-container").count, Image.count

    file = fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'test.png'), 'image/png')
    assert_difference('ActiveStorage::Attachment.count', 1) do
      assert_difference('Image.count', 1) do
        post images_url, params: { image: { description: @image.description, title: @image.title, image_file: file }}
        assert_response :redirect
      end
    end

    get "/en/userpanel/show_images", xhr: true, as: :js
    assert_response :success

    assert_equal @response.body.scan("widget-container").count, Image.count
  end

  test "updating an Image" do
    log_in(@user, "123456")
    get "/en/userpanel"
    assert_response :success

    get "/en/userpanel/show_images", xhr: true, as: :js
    assert_response :success

    assert_no_difference 'ActiveStorage::Attachment.count' do
      assert_no_difference 'Image.count' do
        patch image_url(@image), params: { image: { description: @image.description + "abc", title: @image.title + "def" }}
        assert_response :success
      end
    end
    

    assert_equal Image.find(@image.id).description, @image.description + "abc"
    assert_equal Image.find(@image.id).title, @image.title + "def"

    get "/en/userpanel/show_images", xhr: true, as: :js
    assert_response :success

    assert_equal @response.body.scan("widget-container").count, Image.count
  end
end