class Email
  def self.send_email(user, body)
    Pony.options = {
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

    Pony.mail :to => user.email,
    :from => 'Makers AirBnB',
    :subject => "Hello from Makers AirBnB",
    :body => body
  end
end
