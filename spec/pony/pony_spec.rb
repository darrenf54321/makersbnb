
describe Pony do

  before(:each) do
    allow(Pony).to receive(:deliver)
  end

  it "sends mail" do
    expect(Pony).to receive(:deliver) do |mail|
      expect(mail.to).to eq [ 'batman@hotmail.com' ]
      expect(mail.from).to eq [ 'airbnb@gmail.com' ]
      expect(mail.subject).to eq 'Thanks for contacting us'
      expect(mail.body).to eq 'Here are your reservation details.'
    end
    Pony.mail(:to => 'batman@hotmail.com', :from => 'airbnb@gmail.com', :subject => 'Thanks for contacting us', :body => 'Here are your reservation details.')
  end

end
