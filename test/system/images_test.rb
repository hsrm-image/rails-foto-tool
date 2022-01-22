require "application_system_test_case"

class ImagesTest < ApplicationSystemTestCase
  setup do
    @image = images(:one)
    @user = users(:adminOne)
    perform_enqueued_jobs
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
  
end
