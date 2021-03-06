ENV["RACK_ENV"] ||= "development"

require 'sinatra/base'
require_relative 'data_mapper_setup'
require 'sinatra/flash'
require 'sinatra/partial'
require 'pony'
require 'envyable'
require 'stripe'
require_relative 'models/space'
require_relative 'models/user'
require_relative 'models/email'

class BnB < Sinatra::Base
  use Rack::MethodOverride
  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash
  register Sinatra::Partial
  set :partial_template_engine, :erb
  enable :partial_underscores

# --Stripe information + setting private keys with Envyable --
  Envyable.load('config/env.yml', 'test')
  set :publishable_key, ENV['PUBLISHABLE_KEY_TEST']
  set :secret_key, ENV['SECRET_KEY_TEST']
  Stripe.api_key = settings.secret_key

  def current_user
    @current_user ||= User.get(session[:user_id])
  end

  before do
    @user = current_user
  end

  get '/' do
    erb :'home'
  end

  get '/home' do
     erb :'register'
  end
# --- REGISTER ----
  get '/register' do
    @user = User.new
    erb :'register'
  end

  post '/register' do
    @user = User.new(first_name: params[:first_name],
                     last_name: params[:last_name],
                     email: params[:email],
                     password: params[:password],
                     password_confirmation: params[:password_confirmation])
      if @user.save
        session[:user_id] = @user.id
        Email.send_email(@user, erb(:'emails/registration', layout: false))
        erb :'welcome'
      else
        flash.now[:errors] = ['Ooops, your password did not match - please try again']
        erb :'register'
      end
  end

# --- SIGN IN ----
  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions' do
    user = User.authenticate(params[:email], params[:password])
      if user
        session[:user_id] = user.id
        erb :'sessions/welcome_back'
      else
        flash.now[:errors] = ['The email or password is incorrect']
        erb :'sessions/new'
      end
    end

    delete '/sessions' do
    session[:user_id] = nil
    flash.keep[:notice] = 'Goodbye!'
    redirect to '/home'
 end

# --- ADD + LIST SPACE ----

  get '/spaces' do
    @spaces = Space.all
    erb :spaces
  end

  get '/spaces/new' do
    erb :'spaces/new'
  end

  post '/spaces' do
    if current_user
      Space.create(name: params[:name],
                     description: params[:description],
                     price: params[:price],
                     available_from: params[:available_from],
                     available_to: params[:available_to],
                     user: current_user)
      redirect '/spaces'
    else
      flash.now[:errors] = ['Please register or login to list a space']
      erb :'register'
    end
  end

  post '/spaces/update/:id' do
    @space = Space.get(params[:id])
    @space.update(:name => params[:name],
                 :description => params[:description],
                 :price => params[:price],
                 :available_from => params[:available_from],
                 :available_to => params[:available_to])
    redirect '/spaces'
  end

  get '/spaces/filter_dates' do
    @spaces = Space.search_availability(session[:available_from], session[:available_to])
    erb :spaces
  end

  post '/spaces/filter_dates' do
    session[:available_from] = Date.parse(params[:available_from])
    session[:available_to] = Date.parse(params[:available_to])
    redirect '/spaces/filter_dates'
  end

  get '/spaces/:id' do
    @space = Space.get(params[:id])
    erb :'space'
  end

  get '/spaces/edit/:id' do
    @space = Space.get(params[:id])
    erb :'spaces/edit'
  end

# --- REQUESTS ----

  get '/requests' do
    erb :requests
  end

  post '/request/new' do
    session[:check_in] = Date.parse(params[:check_in])
    session[:check_out] = Date.parse(params[:check_out])
    session[:space_id] = params[:space_id]
    redirect '/request/finalise'
  end

  get '/requests/received/:id' do
    @booking = Booking.get(params[:id])
    erb :'request'
  end

  get '/request/finalise' do
    @check_in = session[:check_in]
    @check_out = session[:check_out]
    @space = Space.get(session[:space_id])
    session[:price] = @space.calculate_price(@check_in, @check_out)
    @price = session[:price]
    erb :'finalise+pay'
  end

  # -- PAYMENTS --

  post '/charge' do
    @amount = (session[:price]*100)

    customer = Stripe::Customer.create(
      :email         => 'customer@example.com',
      :source        => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :amount        => @amount,
      :description   => 'Sinatra Charge',
      :currency      => 'usd',
      :customer      => customer.id
    )

    Booking.create(check_in: session[:check_in],
                   check_out: session[:check_out],
                   status: "unconfirmed",
                   space: Space.get(session[:space_id]),
                   user: current_user,
                   price: @amount
                   )
    redirect 'payment/successful'
  end

  get '/payment/successful' do
    @price = session[:price]
    erb :charge
  end

  error Stripe::CardError do
    env['sinatra.error'].message
  end

  # -- BOOKINGS --

  get '/bookings/confirm/:id' do
    @booking = Booking.get(params[:id])
    @booking.update(:status => "confirmed")
    @guest = @booking.user
    Email.send_email(@guest, erb(:'emails/booking', layout: false))
    redirect '/bookings'
  end

  get '/bookings/reject/:id' do
    @booking = Booking.get(params[:id])
    @booking.update(:status => "rejected")
    redirect '/bookings'
  end

  get '/bookings' do
    erb :bookings
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
