require "application_system_test_case"

class CollectionsTest < ApplicationSystemTestCase
  setup do
    @collection = collections(:one)
    @image = images(:one)
    @user = users(:one)

    perform_enqueued_jobs
    sign_in(@user)
  end

  test "viewing image in collection" do
    @collection.images << @image
    @collection.save!

    assert_includes Collection.find(@collection.id).images, @image
    visit collections_url
    page.all('.grid-element').last.click

    page.all('.grid-element').last.click
    assert_selector "h1#image-title", text: @image.title
  end

  test "creating a Collection" do
    visit userpanel_url
    within "#content" do
      click_on I18n.t("userpanels.index.collections")
    end

    find('span', text: I18n.t("userpanels.views.show_collections.createNewCollection")).click

    fill_in "title", with: @collection.name + "yo"
    assert_difference "Collection.count", 1 do
      within ".hoverCard" do
        find('span', text: I18n.t("userpanels.views.collection_modal.create")).click
      end

      assert_text I18n.t("controllers.created", resource: @collection.name + "yo")
    end

    assert_equal Collection.last.name, @collection.name + "yo"
  end

  test "updating a Collection" do
    visit userpanel_url
    within "#content" do
      click_on I18n.t("userpanels.index.collections")
    end

    within ".collection-container" do
      click_on @collection.name[0..6]
    end

    assert_no_difference "Collection.count" do
      # First delete the prefilled texts
      @collection.name.length.times { find(".attr_edit_name").send_keys(:backspace) }
      # Now fill in the new text
      fill_in with: @collection.name + "_edit", class: "attr_edit_name"

      find(".doneButton").click
      assert_text I18n.t("controllers.updated", resource: @collection.name + "_edit"), wait: 5
    end

    assert_equal Collection.find(@collection.id).name, @collection.name + "_edit"
  end

  test "destroying a Collection" do
    visit userpanel_url
    within "#content" do
      click_on I18n.t("userpanels.index.collections")
    end

    within ".collection-container" do
      click_on @collection.name[0..6]
    end

    assert_difference "Collection.count", -1 do
      find(".deleteButton").click
      assert_text I18n.t("controllers.destroyed", resource: @collection.name), wait: 5
    end

    assert_equal Collection.exists?(@collection.id), false
  end



  test "setting cover image" do
    @image.collections << @collection
    @image.save!
    assert_nil Collection.find(@collection.id).header_image
    
    visit userpanel_url
    within "#content" do
      click_on I18n.t("userpanels.index.collections")
    end

    within ".collection-container" do
      click_on @collection.name[0..6]
    end

    within ".headerImages" do
      find("input[data-img='#{@image.id}']").click
    end
    assert_text I18n.t("controllers.set_collection_header", img: @image.title, col: @collection.name)

    assert_equal Collection.find(@collection.id).header_image, @image

    # Now removing the header image:
    within ".collection-container" do
      click_on @collection.name[0..6]
    end

    within ".headerImages" do
      find("input[data-img='#{@image.id}']").click
    end
    assert_text I18n.t("controllers.rem_collection_header", col: @collection.name)
    assert_nil Collection.find(@collection.id).header_image
  end
end
