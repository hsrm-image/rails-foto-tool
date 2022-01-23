require "test_helper"

class UserpanelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @image = images(:one)
    @collection = collections(:one)
    sign_in(@user)
  end

  test "should not get index as visitor" do
    sign_out(@user)
    get userpanel_url
    assert_redirected_to new_user_session_url
  end

  test "should get index" do
    get userpanel_url
    assert_response :success
  end

  test "should show images" do
    get userpanel_show_images_path, as: :js, xhr: true
    assert_response :success
    assert_match @image.title[0..6], @response.body
  end

  test "should show collections" do
    get userpanel_show_collections_path, as: :js, xhr: true
    assert_response :success
    assert_match @collection.name[0..6], @response.body
  end

  test "should show details" do
    get userpanel_show_details_path, params: {img: @image.id}, as: :js, xhr: true
    assert_response :success
    assert_match @image.title, @response.body
    assert_match @image.description, @response.body
  end

  test "should show collection creation modal" do
    get userpanel_create_collection_path, params: {img: @image.id}, as: :js, xhr: true
    assert_response :success
  end

  test "should show collection details" do
    get userpanel_show_collection_details_path, params: {collection_id: @collection.id}, as: :js, xhr: true
    assert_response :success
    assert_match @collection.name, @response.body
  end

  test "should add image to collection" do
    assert_difference "Collection.find(#{@collection.id}).images.count", 1 do
      post userpanel_join_collection_image_path, params: {image_id: @image.id, collection_id: @collection.id}
    end
    assert_response :success

    assert_includes Collection.find(@collection.id).images, @image

    # should not add images to collection twice
    assert_no_difference "Collection.find(#{@collection.id}).images.count" do
      post userpanel_join_collection_image_path, params: {image_id: @image.id, collection_id: @collection.id}
    end
    assert_response :success

  end

  test "should remove images from collection" do
    post userpanel_join_collection_image_path, params: {image_id: @image.id, collection_id: @collection.id}
    assert_response :success
    assert_difference "Collection.find(#{@collection.id}).images.count", -1 do
      post userpanel_part_collection_image_path, params: {image_id: @image.id, collection_id: @collection.id}
    end
    assert_response :success

    # should not remove non existant image
    assert_no_difference "Collection.find(#{@collection.id}).images.count" do
      post userpanel_part_collection_image_path, params: {image_id: @image.id, collection_id: @collection.id}
    end
    assert_response :success
  end

  test "should set collection header image" do
    post userpanel_join_collection_image_path, params: {image_id: @image.id, collection_id: @collection.id}
    assert_response :success

    assert_nil Collection.find(@collection.id).header_image
    post userpanel_set_collection_header_path, params: {image_id: @image.id, collection_id: @collection.id}
    assert_response :success

    assert_equal Collection.find(@collection.id).header_image, @image

    # now remove the header image!
    post userpanel_set_collection_header_path, params: {image_id: '', collection_id: @collection.id}
    assert_response :success

    assert_nil Collection.find(@collection.id).header_image
  end


end
