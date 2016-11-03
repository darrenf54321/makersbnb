ENV["RACK_ENV"] ||= "development"

require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/partial'
require_relative 'models/space'
require_relative 'models/user'

class BnB < Sinatra::Base


use Rack::MethodOverride

  enable :sessions
  register Sinatra::Flash
  register Sinatra::Partial
  set :session_secret, 'super secret'
  set :partial_template_engine, :erb
  enable :partial_underscores

<<<<<<< HEAD

  def current_user
    @current_user ||= User.get(session[:user_id])
  end

=======
  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end
>>>>>>> dec532dd49deb8b4dcece610417e250476b08bd0

  get '/' do
    erb :'home'
  end

  get '/home' do
     erb :'register'
  end

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
        erb :'welcome'
      else
        flash.now[:errors] = ['Ooops, your password did not match - please try again']
        erb :'register'
      end
  end

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
                 available_to: params[:available_to])
    redirect '/spaces'
  else
  flash.now[:errors] = ['Please register or login to list a space']
    erb :'register'
  end
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
    erb :'space_listing'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
