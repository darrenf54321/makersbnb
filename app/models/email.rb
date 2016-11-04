class Email


  def self.send_user_registration(user)
    RestClient.post "https://api:key-cabbad85892465a36d57c781d770fd93"\
    "@api.mailgun.net/v3/sandbox2738eca9717943f9b144e797a359f47c.mailgun.org/messages",
    :from => "Mailgun Sandbox <postmaster@sandbox02399209c9bf4af2acf3e60313fe7806.mailgun.org>",
    :to => "#{user.first_name} <#{user.email}>",
    :subject => "Welcome!",
    :text => "Hello #{user.first_name}, Thank you for registering"
  end




 # def initialize(mailer: nil)
 #   @mailer = mailer || Mailgun::Client.new('https://api:key-eb289188a1aa2f3a74672a158bf1477f')
 # end
 #
 # def self.call(user, mailer = nil)
 #   new(mailer: mailer).call(user)
 # end
 #
 # def call(user)
 #   mailer.messages.send_email("sandbox2738eca9717943f9b144e797a359f47c.mailgun.org", {from: "noreply@makersbnb.com",
 #       to: user.email,
 #       subject: "Makers BnB Registration",
 #       text: "Thank you for registering with Makers BnB" })
 # end
 #
 # private
 # attr_reader :mailer
end
