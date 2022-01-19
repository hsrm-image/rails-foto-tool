require "test_helper"

class InvitationMailTest < ActionMailer::TestCase

  def setup
    Devise.mailer_sender = "test@example.com"
    @user = User.invite!(:email => users(:one).email + "1")
    @mail = ActionMailer::Base.deliveries.last
  end

  test "should send invitation mail" do
    assert_not_nil @mail
  end

  test "should create new user with correct mail" do
    ActionMailer::Base.deliveries = []
    assert_difference "User.count", 1 do
        User.invite!(:email => users(:one).email + "2")
    end

    assert_equal 1, User.where(:email => users(:one).email + "2").count
  end

  test "should not send mail to already registered user" do
    ActionMailer::Base.deliveries = []
    assert_no_difference "User.count" do
        User.invite!(:email => users(:one).email)
    end

    assert_nil ActionMailer::Base.deliveries.last
  end

  test "should set content type to multipart" do
    assert_match /^multipart\/alternative; boundary="[^"]+"; charset=UTF-8/, @mail.content_type
  end

  test "should send invitation to the user email" do
    assert_equal [@user.email], @mail.to
  end

  test "should use correct sender" do
    assert_equal [Devise.mailer_sender], @mail.from
  end


  test "should have user mail in body" do
    assert_match /#{@user.email}/, @mail.html_part.body.decoded
    assert_match /#{@user.email}/, @mail.text_part.body.decoded
  end

  test "should have accept link in body" do
    assert_match /<a href=\"http:\/\/[^:]+:\d+\/..\/users\/invitation\/accept\?invitation_token=[^"]+">/, @mail.html_part.body.decoded
    assert_match /http:\/\/[^:]+:\d+\/..\/users\/invitation\/accept\?invitation_token=[^"]+/, @mail.text_part.body.decoded
  end

  test "should have correct language" do
    assert_not_equal :de, I18n.default_locale, "Default language should be different from ':de' for this test"
    ActionMailer::Base.deliveries = []
    I18n.with_locale(:de) do
        User.invite!(:email => users(:one).email + "2")
    end
    mail = ActionMailer::Base.deliveries.last

    assert_equal I18n.t("devise.mailer.invitation_instructions.subject", locale: :de), mail.subject
    assert_match I18n.t("devise.mailer.invitation_instructions.ignore", locale: :de), mail.html_part.body.decoded
    assert_match I18n.t("devise.mailer.invitation_instructions.ignore", locale: :de), mail.text_part.body.decoded
  end

end