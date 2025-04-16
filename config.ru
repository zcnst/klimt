# frozen_string_literal: true

require 'dotenv'
Dotenv.load

require './app'
run Sinatra::Application
