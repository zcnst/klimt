# frozen_string_literal: true

puts "load file #{__FILE__}"
require 'dotenv'
Dotenv.load

require './app'
run Sinatra::Application
