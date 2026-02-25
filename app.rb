require "sinatra"
require "sinatra/activerecord"

use Rack::MethodOverride
enable :sessions
set :database, {adapter: "sqlite3", database: "foo.sqlite3"}

# require models
require_relative "models/snippet"

not_found { erb :not_found }

get "/" do
  snippets = Snippet.all

  erb :root, locals: {snippets: snippets}
end

post "/snippets" do
  snippet = Snippet.new params[:snippet]

  redirect "/" if snippet.save

  session[:snippet] = params[:snippet]
  session[:errors] = snippet.errors
  redirect "/new"
end

get "/new" do
  snippet = Snippet.new session[:snippet]
  errors = session[:errors]

  session[:snippet] = {}
  session[:errors] = nil

  erb :new, locals: {snippet: snippet, errors: errors}
end

get "/s/:slug" do
  snippet = Snippet.find_by(slug: params[:slug])

  if !snippet
    status 404
    return erb :not_found
  end

  snippet.html_content || "<h1>Could not find content</h1>"
end

get "/s/:slug/edit" do
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
  snippet = Snippet.find_by slug: params[:slug]

  redirect "/" if snippet.update params[:snippet]

  session[:errors] = snippet.errors
  session[:snippet] = snippet.serializable_hash except: [:id]

  redirect "/s/#{params[:slug]}/edit"
end

delete "/s/:slug" do
  snippet = Snippet.find_by slug: params[:slug]

  snippet.destroy if snippet

  redirect "/"
end
