require 'spec_helper'

feature "request booking" do
  scenario 'as a customer I want to request a booking' do
    skip "From Michael: Not sure how to test this whilst using stripe, need to explore this..."
    create_user_spaces
    sign_in
    visit '/spaces'
    find('ul > li:first-child > a').click()
    fill_in :check_in, with: '2017/03/01'
    fill_in :check_out, with: '2017/06/01'
    click_button 'Request booking'
    expect(current_path).to eq '/request/finalise'
    expect(page).to have_content 'Finalise your booking!'
    click_link 'Confirm'
    expect(page).to have_content "Requests I've made"
    expect(page).to have_content "2017"
  end

end
