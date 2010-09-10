require 'rubygems'
require 'sinatra'

Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :production
)


require 'sanctionwatch.rb'
run Sinatra::Application