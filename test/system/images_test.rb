require "application_system_test_case"

class ImagesTest < ApplicationSystemTestCase
  setup do
    @image = images(:one)
    @user = users(:adminOne)
  end

  test "visiting the index" do
    visit images_url
    assert_selector "h1", text: I18n.t("images.index.all")
  end


  test "viewing an Image" do
    visit images_url
    page.all('.grid-element').last.click

    assert_selector "h1", text: @image.title
  end

  # attach_file("image_image_file", Rails.root.join('test', 'fixtures', 'files', 'exif.jpg'), make_visible: true)
  



  test "destroying a Image" do
    sign_in(@user)
    visit images_url
    page.all('.grid-element').last.click

    click_on I18n.t("images.description.more"), match: :first
    assert_difference "Image.count", -1 do
      accept_confirm do
        click_on I18n.t("images.description.delete"), match: :first, wait: 2
      end

    assert_text I18n.t("controllers.destroyed", resource: I18n.t("images.resource_name"))
    end
    assert(!Image.exists?(@image.id))
  end
end
