require 'mailgun'
class EmailReg

 def initialize(mailer: nil)
   @mailer = mailer || Mailgun::Client.new(ENV["your_api_key"])
 end

 def self.call(user, mailer = nil)
   new(mailer: mailer).call(user)
 end

 def call(user)
   mailer.send_message(ENV["mailgun_domain_name"], {from: "noreply@makersbnb.com",
       to: user.email,
       subject: "Makers BnB Registration",
       text: "Thank you for registering with Makers BnB" })
 end

 private
 attr_reader :mailer
end
