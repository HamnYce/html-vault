require "sinatra"
require "sinatra/activerecord"

set :database, {adapter: "sqlite3", database: "foo.sqlite3"}
enable :sessions

# require models
require_relative "models/snippet"

get "/" do
  snippets = Snippet.all

  erb :root, locals: {snippets: snippets}
end

get "/new" do
  snippet = Snippet.new title: session[:snippet_title], tags: session[:snippet_tags], html_content: session[:snippet_html_content]
  errors = session[:errors]
  session[:snippet_title] = nil
  session[:snippet_html_content] = nil
  session[:snippet_tags] = nil
  session[:errors] = nil

  erb :new, locals: {snippet: snippet, errors: errors}
end

post "/snippets" do
  title = params[:snippet_title]
  html_content = params[:snippet_html_content]
  tags = params[:snippet_tags]

  snippet = Snippet.new title: title, html_content: html_content, tags: tags

  if !snippet.save
    session[:snippet_title] = params[:snippet_title]
    session[:snippet_html_content] = params[:snippet_html_content]
    session[:snippet_tags] = params[:snippet_tags]
    session[:errors] = snippet.errors
    redirect "/new"
  end

  redirect "/"
end

get "/s/:slug" do
  snippet = Snippet.find_by(slug: params[:slug])
  snippet.html_content || "<h1>Could not find content</h1>"
end
