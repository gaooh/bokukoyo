require File.dirname(__FILE__) + '/../test_helper'
require 'mailer'

class MailerTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    
    @user_info = UserInfo.new
    @user_info.email = "asami@drecom.co.jp"
    @user_info.nickname = "えびせん"
    
    @auth_info = AuthEmail.new
    
    Mailer.deliver_first_auth(@user_info,@auth_info, @expected.date)
    
  end

  def test_first_auth
    @expected.subject = 'Mailer#first_auth'
    @expected.body    = read_fixture('first_auth')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Mailer.create_first_auth(@expected.date).encoded
  end
    
  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
