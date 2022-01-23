require "application_system_test_case"

class ImagesTest < ApplicationSystemTestCase
  setup do
    @image = images(:one)
    @user = users(:adminOne)
    @collection = collections(:two)
    perform_enqueued_jobs
    sign_in(@user)
  end

  test "visiting the index" do
    sign_out(@user)
    visit images_url
    assert_selector "h1", text: I18n.t("images.index.all")
  end


  test "viewing an Image" do
    sign_out(@user)
    visit images_url
    page.all('.grid-element').last.click

    assert_selector "h1", text: @image.title
  end

  test "uploading an Image" do
    visit userpanel_url
    within "#content" do
      click_on I18n.t("userpanels.index.images")
    end

    assert_difference "Image.count", 1 do
      attach_file(Rails.root.join('test', 'fixtures', 'files', 'exif.jpg')) do
        find("#upload").click
      end
      within ".img-container" do
        assert_text "exif"
      end
    end
  end

  test "uploading multiple images" do
    n = 10
    assert n > 1, "Please select a number equal or greater than 1 for multiple file uploads"
    visit userpanel_url
    within "#content" do
      click_on I18n.t("userpanels.index.images")
    end

    images = []
    (1..n).each do |x|
      images << Rails.root.join('test', 'fixtures', 'files', 'exif.jpg')
    end

    assert_difference "Image.count", n do
      attach_file(images) do
        find(".dropzone.dz-clickable").click
      end
 
      within ".img-container" do
        assert_text "exif", count: n, wait: 10
      end
    end
  end

  test "deleting an Image" do
    visit userpanel_url
    within "#content" do
      click_on I18n.t("userpanels.index.images")
    end

    within ".img-container" do
      click_on @image.title[0..6]
    end

    assert_difference "Image.count", -1 do
      find(".deleteButton").click
      assert_text I18n.t("controllers.destroyed", resource: @image.title)
    end

    assert_equal Image.exists?(@image.id), false
  end

  test "updating an Image" do
    visit userpanel_url
    within "#content" do
      click_on I18n.t("userpanels.index.images")
    end

    within ".img-container" do
      click_on @image.title[0..6]
    end

    assert_no_difference "Image.count" do
      within "#details" do
        # First delete the prefilled texts
        @image.title.length.times { find(".attr_edit_title").send_keys(:backspace) }
        @image.description.length.times { find(".attr_edit_description").send_keys(:backspace) }

        # Now fill in the new text
        fill_in class: "attr_edit_title", with: @image.title + "_edit"
        find(".doneButton").click
        fill_in class: "attr_edit_description", with: @image.description + "_edit"
        find(".doneButton").click
      end
      assert_text I18n.t("controllers.updated", resource: @image.title + "_edit")
    end

    assert_equal Image.find(@image.id).title, @image.title + "_edit"
    assert_equal Image.find(@image.id).description, @image.description + "_edit"
  end


  test "adding image to collection" do
    visit userpanel_url
    within "#content" do
      click_on I18n.t("userpanels.index.images")
    end

    within ".img-container" do
      click_on @image.title[0..6]
    end

    assert_difference "Collection.find(#{@collection.id}).images.count", 1 do
      within ".collectionList" do
        find("input[data-collection='#{@collection.id}']").click
      end

      assert_text I18n.t("controllers.image_add_collection", img: @image.title, col: @collection.name)
    end

    assert_includes Collection.find(@collection.id).images, @image
  end
end
