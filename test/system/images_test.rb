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
    page.first(".grid-element").click

    assert_text @image.title
  end

  test "creating a Image" do
    visit images_url
    click_on "New Image"
    assert_selector "p.alert", text: "You need to sign in or sign up before continuing."
    fill_in "Email", with: @user.email
    fill_in "Password", with: "123456"
    within "div.actions" do
      click_on "Log in"
    end

    assert_selector "p.notice", text: "Signed in successfully."
    assert_selector "h1", text: "New image"
    fill_in "Description", with: @image.description
    fill_in "Title", with: @image.title
    attach_file("image_image_file", Rails.root.join('test', 'fixtures', 'files', 'exif.jpg'), make_visible: true)
    click_on "Save"

    assert_text "Image was successfully created"
    click_on "Back"
  end

  test "updating a Image" do
    visit images_url
    click_on "Edit", match: :first

    fill_in "Description", with: @image.description
    fill_in "Title", with: @image.title
    click_on "Update Image"

    assert_text "Image was successfully updated"
    click_on "Back"
  end

  test "destroying a Image" do
    sign_in(@user)
    visit images_url
    page.first(".grid-element").click

    click_on I18n.t("images.description.more"), match: :first

    page.accept_confirm do
      click_on I18n.t("images.description.delete"), match: :first, wait: 2
    end

    assert_text "Image was successfully destroyed"
  end
end
