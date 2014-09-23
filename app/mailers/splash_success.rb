class SplashSuccess < ActionMailer::Base
  default from: "alex.jordan@spectafresh.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.splash_success.splash_page_confirmation.subject
  #
  def splash_page_confirmation(useremail)
    @useremail = useremail
    @greeting = "Hi"

    mail(:to => useremail, :bcc => ["alex.jordan.j@gmail.com, kme3p@virginia.edu"], :subject => "SpectaFresh - New Splash Page User")
  end
end
