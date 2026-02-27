require "sinatra"
require "sinatra/activerecord"
require "securerandom"
require "dotenv/load"

# require models
require_relative "models/snippet"
require_relative "models/user"

# next steps are
# fix that hmac message
# add a middleware to authenticate against username and password (do the simplest shitway)
# deploy on railway or some other easy way

use Rack::MethodOverride

enable :sessions

set :bind, ENV.fetch("HOST", "0.0.0.0")
set :port, ENV.fetch("PORT", 8080)
set :session_secret, ENV.fetch("SESSION_SECRET") { SecureRandom.hex(64) }
set :host_authorization, permitted_hosts: ENV.fetch("PERMITTED_HOSTS").split(",").map(&:strip)


set :database, {adapter: "sqlite3", database: ENV.fetch("DATABASE_URI")}

not_found { erb :not_found }

helpers do
  def logged_in?
    !!session[:user_id]
  end

  def protected!
    halt 401, "Not Authorized" unless logged_in?
  end
end

get "/logout" do
  session[:user_id] = nil
  redirect "/login"
end

get "/login" do
  erb :login
end

post "/login" do
  user = User.find_by username: params[:username]

  return erb :login if !user
  return erb :login if !user.authenticate params[:password]

  session[:user_id] = user.username
  redirect "/"
end

get "/" do
  protected!

  snippets = Snippet.all

  erb :root, locals: {snippets: snippets}
end

post "/snippets" do
  protected!

  snippet = Snippet.new params[:snippet]

  redirect "/" if snippet.save

  session[:snippet] = params[:snippet]
  session[:errors] = snippet.errors
  redirect "/new"
end

get "/new" do
  protected!

  snippet = Snippet.new session[:snippet]
  errors = session[:errors]

  session[:snippet] = {}
  session[:errors] = nil

  erb :new, locals: {snippet: snippet, errors: errors}
end

get "/s/:slug" do
  protected!

  snippet = Snippet.find_by(slug: params[:slug])

  if !snippet
    status 404
    return erb :not_found
  end

  snippet.html_content || "<h1>Could not find content</h1>"
end

get "/s/:slug/edit" do
  protected!

  snippet = Snippet.find_by slug: params[:slug]

  if !snippet
    status 404
    return erb :not_found
  end

  snippet.assign_attributes(session[:snippet] || {})
  errors = session[:errors]

  session[:snippet] = {}
  session[:errors] = nil

  erb :new, locals: {snippet: snippet, errors: errors}
end

patch "/s/:slug" do
  protected!

  snippet = Snippet.find_by slug: params[:slug]

  redirect "/" if snippet.update params[:snippet]

  session[:errors] = snippet.errors
  session[:snippet] = snippet.serializable_hash except: [:id]

  redirect "/s/#{params[:slug]}/edit"
end

delete "/s/:slug" do
  protected!

  snippet = Snippet.find_by slug: params[:slug]

  snippet.destroy if snippet

  redirect "/"
end
