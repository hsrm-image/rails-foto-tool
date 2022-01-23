require "test_helper"

class CollectionsControllerTest < ActionDispatch::IntegrationTest
    setup do
        @user = users(:one)
        @collection = collections(:one)
        @image = images(:one)
        sign_in(@user)
    end

    test "should get index" do
        get collections_path
        assert_response :success
    end

    test "should create collection" do
        assert_difference 'Collection.count', 1 do
            post collections_path, params: { collection: { name: @collection.name } }, xhr: true, as: :js
        end

        assert_response :success
    end

    test "should show collection" do
        get collection_url(@collection)
        assert_response :success
    end

    test "should show image inside collection" do
        @collection.images << @image
        @collection.save!

        assert_includes Collection.find(@collection.id).images, @image

        get collection_image_path(@collection, @image)
        assert_response :success
    end

    test "should update collection" do
        patch collection_url(@collection), params: { collection: { name: @collection.name + "abc" } }, xhr: true, as: :js
        
        assert_equal Collection.find(@collection.id).name, @collection.name + "abc"
    end

    test "should destroy collection" do
        assert_difference('Collection.count', -1) do
            delete collection_url(@collection), xhr: true, as: :js
        end

        assert_equal Collection.exists?(@collection.id), false
    end
end
