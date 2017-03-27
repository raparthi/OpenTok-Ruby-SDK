require 'sinatra/base'
require 'opentok'

# raise "You must define API_KEY and API_SECRET environment variables" unless ENV.has_key?("API_KEY") && ENV.has_key?("API_SECRET")

class Sip < Sinatra::Base

  set :api_key, ENV['API_KEY']
  set :opentok, OpenTok::OpenTok.new(api_key, ENV['API_SECRET'])

  set :session, opentok.create_session(:media_mode => :routed)
  # set :erb, :layout => :layout

  get '/' do
    api_key = settings.api_key
    session_id = settings.session.session_id

    token = settings.opentok.generate_token(session_id, :role => :moderator)
    puts session_id,token
    erb :index, :locals => {
        :api_key => api_key,
        :session_id => session_id,
        :token => token
    }
  end

  post '/sip/start' do
    settings.opentok.dial(params[:session_id], params[:token], 'sip:balakishore@openrcs.com', {headers: {}, auth: {username: 'balakishroe', password: 'testtest1'}})
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end
