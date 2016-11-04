require 'spec_helper'

feature "Update a space" do

  before(:each) do
    create_user_spaces
  end

  it "displays an edit button if I own the space I'm viewing" do
    sign_in_host
    visit('/spaces')
    expect(page).to have_content "You own this"
    find('ul > li:first-child > a').click()
    expect(page).to have_content "You own this property. Edit listing"
  end

  it "doesn't display an edit button if I don't own the space I'm viewing" do
    sign_in
    visit('/spaces')
    find('ul > li:first-child > a').click()
    expect(page).to_not have_content "You own this property. Edit listing"
  end

  it "allows me to edit the listing" do
    sign_in_host
    visit('/spaces')
    find('ul > li:first-child > a').click()
    click_link('Edit listing')
    expect(page).to have_content "Edit Space"
    fill_in :name, with: 'Reasonably Relaxing Space'
    fill_in :description, with: 'have a break at our BnB'
    click_button 'Submit updated details'
    expect(current_path).to eq '/spaces'
    expect(page).to_not have_content('Beautiful Relaxing Space')
    expect(page).to_not have_content('have fun at our BnB')
    expect(page).to have_content('Reasonably Relaxing Space')
    expect(page).to have_content('have a break at our BnB')
  end

end
