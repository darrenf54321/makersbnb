def create_user_spaces
  host = User.create(
    first_name: 'batman',
    last_name: 'wayne',
    email: "batman@hotmail.com",
    password: "123",
    password_confirmation: "123")

  User.create(
    first_name: 'homeless',
    last_name: 'homeless',
    email: "homeless@hotmail.com",
    password: "123",
    password_confirmation: "123")

  Space.create(name: 'Beautiful Relaxing Space',
               description: 'have fun at our BnB',
               price: "50",
               available_from: '2017/01/01',
               available_to: '2017/07/07',
               user: host)

  Space.create(name: 'New Space',
               description: 'have an okay time at our BnB',
               price: "50",
               available_from: '2017/01/01',
               available_to: '2017/07/07',
               user: host)

  Space.create(name: 'Old Space',
              description: 'have a miserable time at our BnB',
              price: "60",
              available_from: '2015/01/01',
              available_to: '2015/07/07',
              user: host)

end

def sign_in
  visit '/sessions/new'
  fill_in :email, with: "homeless@hotmail.com"
  fill_in :password, with: "123"
  click_button 'Sign in'
end

def create_booking
  Booking.create(check_in: Date.parse("2017/01/01"),
                check_out: Date.parse("2017/01/01"),
                status: "unconfirmed",
                space: Space.get(1),
                user: User.get(2))
end

def sign_in_host
  visit '/sessions/new'
  fill_in :email, with: "batman@hotmail.com"
  fill_in :password, with: "123"
  click_button 'Sign in'
end

def request_booking
  create_user_spaces
  visit '/spaces/1'
  expect(current_path).to eq '/spaces/1'
  fill_in 'check_in', with: '2016/11/01'
  fill_in('check_out', with: '2016/11/08')
  click_button "Request Booking"
end
