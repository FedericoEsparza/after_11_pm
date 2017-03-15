require 'sinatra'
require 'deep_clone'
require './app'

enable :sessions
helpers WebAppHelper

get '/' do
  erb :index, layout: true
end

get '/show_me' do
  erb "<a href=\"#{session[:question_sheet]}\"> Question Sheet link</a> \n <a href=\"#{session[:solution_sheet]}\"> Solution Sheet link</a>"
end

get '/temp/*.pdf' do
  send_file "./temp/#{params[:splat].first}.pdf"
end

post '/generate_paper' do
  puts params
  links = gen_worksheets_sheets(params)
  session[:question_sheet] = links[0]
  session[:solution_sheet] = links[1]
  redirect '/show_me'
end
