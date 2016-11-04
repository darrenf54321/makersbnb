require 'spec_helper'

describe EmailReg do

  let!(:user) do
    User.create(email: 'test@test.com', password: 'secret1234', password_confirmation: 'secret1234')
  end
    let(:mail_gun_client){double :mail_gun_client}
    let(:sandbox_domain_name) { ENV["sandbox_domain_name"] }

it "sends an email to the user confirming registration" do
  params = {from: "noreply@makersbnb.com",
            to: user.email,
            subject: "Makers BnB Registration",
            text: "Thank you for registering with Makers BnB" }
            expect(mail_gun_client).to receive(:send_message).with(sandbox_domain_name, params)
  described_class.call(user, mail_gun_client)
end
end
