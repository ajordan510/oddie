require 'test_helper'

class SplashSuccessTest < ActionMailer::TestCase
  test "splash_page_confirmation" do
    mail = SplashSuccess.splash_page_confirmation
    assert_equal "Splash page confirmation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
