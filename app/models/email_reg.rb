require 'mailgun'
class EmailReg

 def initialize(mailer: nil)
   @mailer = mailer || Mailgun::Client.new("cabbad85892465a36d57c781d770fd93")
 end

 def self.call(user, mailer = nil)
   new(mailer: mailer).call(user)
 end

 def call(user)
   mailer.messages.send_email("sandbox2738eca9717943f9b144e797a359f47c.mailgun.org", {from: "noreply@makersbnb.com",
       to: user.email,
       subject: "Makers BnB Registration",
       text: "Thank you for registering with Makers BnB" })
 end

 private
 attr_reader :mailer
end
