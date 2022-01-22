require "application_system_test_case"

class CollectionsTest < ApplicationSystemTestCase
  setup do
    @collection = collections(:one)
    @image = images(:one)
    @user = users(:one)

    perform_enqueued_jobs
    sign_in(@user)
  end

  test "creating a Collection" do
    visit userpanel_url
    within "#content" do
      click_on "Collections"
    end

    find('span', text: "Create New Collection").click

    fill_in "title", with: @collection.name + "yo"
    assert_difference "Collection.count", 1 do
      find('span', text: "create").click

      assert_text "Collection created"
    end

    assert_equal Collection.last.name, @collection.name + "yo"
  end

  test "updating a Collection" do
    visit userpanel_url
    within "#content" do
      click_on "Collections"
    end

    within ".collection-container" do
      click_on @collection.name[0..6]
    end

    assert_no_difference "Collection.count" do
      fill_in with: @collection.name + "_edit", class: "attr_edit_name"

      assert_text @collection.name + "_edit", wait: 5
    end

    assert_equal Collection.find(@collection.id).name, @collection.name + "_edit"
  end

  test "destroying a Collection" do
    visit userpanel_url
    within "#content" do
      click_on "Collections"
    end

    within ".collection-container" do
      click_on @collection.name[0..6]
    end

    assert_difference "Collection.count", -1 do
      find(".deleteButton").click
      assert_text "Collection deleted"
    end

    assert_equal Collection.exists?(@collection.id), false
  end

  test "adding image to collection" do
    visit userpanel_url
    within "#content" do
      click_on "Images"
    end

    within ".img-container" do
      click_on @image.title[0..6]
    end

    assert_difference "Collection.find(#{@collection.id}).images.count", 1 do
      within ".collectionList" do
        find("input[data-collection='#{@collection.id}']").click
      end

      assert_text "Added to Collection(s)"
    end

    assert_includes Collection.find(@collection.id).images, @image
  end

  test "setting cover image" do
    @image.collections << @collection
    @image.save!
    assert_nil Collection.find(@collection.id).header_image
    
    visit userpanel_url
    within "#content" do
      click_on "Collections"
    end

    within ".collection-container" do
      click_on @collection.name[0..6]
    end

    within ".headerImages" do
      find("input[data-img='#{@image.id}']").click
    end
    assert_text "Header Image set!"

    assert_equal Collection.find(@collection.id).header_image, @image

    # Now removing the header image:
    within ".collection-container" do
      click_on @collection.name[0..6]
    end

    within ".headerImages" do
      find("input[data-img='#{@image.id}']").click
    end
    assert_text "Header Image unset!"
    assert_nil Collection.find(@collection.id).header_image
  end
end
