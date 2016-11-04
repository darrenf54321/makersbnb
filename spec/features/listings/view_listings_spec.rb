require 'spec_helper'

describe 'View Listing' do

  before(:each) do
    create_user_spaces
  end

  it "can view a list of all available properties" do
    sign_in
    visit('/spaces')
    expect(page).to have_content "Book a Space"
    expect(page).to have_content 'Beautiful Relaxing Space'
    expect(page).to have_content 'have fun at our BnB'
  end

  it "be able to filter properties by date availability" do
    sign_in
    visit('/spaces')
    expect(page).to have_content "Available from"
    expect(page).to have_content "to"
    fill_in :available_from, with: '2017/02/01'
    fill_in :available_to, with: '2017/02/10'
    click_button 'List spaces'
    expect(page).to_not have_content "Old Space"
    expect(page).to have_content "New Space"
  end

  it 'should display You own this badge if I am an owner' do
    sign_in_host
    visit('/spaces')
    expect(page).to have_content "You own this"
  end

  it 'shouldn\'t display you own this badge if you are not an owner' do
    sign_in
    visit('/spaces')
    expect(page).to_not have_content "You own this"
  end


end
