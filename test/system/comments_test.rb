require "application_system_test_case"

class CommentsTest < ApplicationSystemTestCase
  setup do
    @comment = comments(:one)
    @image = images(:one)
    @user = users(:one)
    @admin = users(:adminOne)
    perform_enqueued_jobs
  end

  test "writing a comment as visitor" do
    visit images_url
    page.all('.grid-element').last.click

    assert_difference "Comment.count", 1 do
      fill_in "comment_username", with: @comment.username 
      fill_in "comment_text", with: @comment.text
      click_on I18n.t("comments.form.post")

      assert_text I18n.t("comments.create.created"), wait: 5
    end
    within first(".comment") do
      assert_text @comment.username 
      assert_text @comment.text 
    end
  end

  test "writing a comment as user" do
    visit images_url
    sign_in(@user)
    page.all('.grid-element').last.click

    assert_difference "Comment.count", 1 do
      fill_in "comment_text", with: @comment.text
      click_on I18n.t("comments.form.post")
      
      assert_text I18n.t("comments.create.created"), wait: 5
      assert_button I18n.t("comments.comment.delete"), count: 1
    end
    within first(".comment") do
      assert_text @user.name 
      assert_text @comment.text 
    end
  end

  test "deleting own comment as visitor" do
    visit images_url
    page.all('.grid-element').last.click

    assert_no_button I18n.t("comments.comment.delete")

    fill_in "comment_username", with: @comment.username 
    fill_in "comment_text", with: @comment.text
    click_on I18n.t("comments.form.post")
    assert_text I18n.t("comments.create.created"), wait: 5

    assert_difference "Comment.count", -1 do
      accept_confirm do
        assert_button I18n.t("comments.comment.delete"), count: 1
        click_on I18n.t("comments.comment.delete")
      end
      assert_text I18n.t('controllers.destroyed', resource: I18n.t("comments.resource_name"))
    end
    
  end


  test "deleting own comment as user" do
    @comment = Comment.new
    @comment.session_id = @user.id
    @comment.user_id = @user.id
    @comment.image_id = @image.id
    @comment.text = "ABCDEEEEE"
    @comment.username = @user.name
    @comment.save!

    visit images_url
    sign_in(@user)
    page.all('.grid-element').last.click

    assert_selector ".comment", minimum: 2 
    assert_button I18n.t("comments.comment.delete"), count: 1

    assert_difference "Comment.count", -1 do
      accept_confirm do
        click_on I18n.t("comments.comment.delete")
      end
      assert_text I18n.t('controllers.destroyed', resource: I18n.t("comments.resource_name"))
    end
  end


  test "deleting others user comment as admin" do
    visit images_url
    sign_in(@admin)
    page.all('.grid-element').last.click

    assert_button I18n.t("comments.comment.delete"), count: page.all(".comment").count

    assert_difference "Comment.count", -1 do
      within first(".comment") do
        accept_confirm do
          click_on I18n.t("comments.comment.delete")
        end
      end

      assert_text I18n.t('controllers.destroyed', resource: I18n.t("comments.resource_name"))
    end
  end

  test "no comment without cookies" do
    visit images_url
    Capybara.current_session.driver.browser.manage.delete_all_cookies
    page.all('.grid-element').last.click

    assert_text I18n.t("comments.form.no_session")
    assert_no_selector "#comment_text"
    assert_no_selector "#comment_username"
  end
end
