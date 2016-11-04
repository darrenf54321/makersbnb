require 'pony'

class Email

def initialize
  Pony.options = {
    :subject => "registration",
    :body => "Welcome",
    :via => :smtp,
    :via_options => {
      :address              => 'smtp.gmail.com',
      :port                 => '587',
      :enable_starttls_auto => true,
      :user_name            => 'airbnbtest54321@gmail.com',
      :password             => 'wrinkles',
      :authentication       => :plain,
      :domain               => "localhost.localdomain"
    }
  }
end
  def email
  Pony.mail :to => @user.email,
  :from => 'Makers AirBnB',
  :subject => 'Thank you for registering and welcome to Makers AirBnB!'

end
