require 'sinatra'
require 'erb_latex'
require './app'

get '/' do
  erb :index, layout: true
end

get '/show_me' do
  system('pdflatex document.tex')
  send_file 'document.pdf'
end

post '/generate_paper' do
  puts params
end
