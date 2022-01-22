require "test_helper"

class PasswordResetTest < ActionMailer::TestCase

    def setup
        Devise.mailer_sender = "test@example.com"
        @user = users(:one)
        @user.send_reset_password_instructions
        @mail = ActionMailer::Base.deliveries.last
      end
    
      test "should send password reset email" do
        assert_not_nil @mail
      end
    
      test "should set content type to html" do
        assert_includes @mail.content_type, "text/html"
      end
    
      test "should set to correct address" do
        assert_equal [@user.email], @mail.to
      end
    
      test "should send from correct address" do
        assert_equal [Devise.mailer_sender], @mail.from
      end
    
    
      test "should set correct repy address" do
        assert_equal [Devise.mailer_sender], @mail.reply_to
      end
    
    
      test "should have correct body" do
        assert_match @user.email, @mail.body.encoded
      end

      test "should contain reset link" do
        assert_match /<a href=\"http:\/\/[^:]+:\d+\/..\/users\/password\/edit\?reset_password_token=[^"]+">/, @mail.body.encoded
      end
    
      test "should have correct language" do
        assert_not_equal :de, I18n.default_locale, "Default language should be different from ':de' for this test"
        ActionMailer::Base.deliveries = []
        I18n.with_locale(:de) do
          @user.send_reset_password_instructions
        end
        mail = ActionMailer::Base.deliveries.last
    
        assert_equal I18n.t("devise.mailer.reset_password_instructions.subject", locale: :de), mail.subject
        assert_match I18n.t("devise.mailer.reset_password_instructions.instruction", locale: :de), mail.body.encoded

      end
end