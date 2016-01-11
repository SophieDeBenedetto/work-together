$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'work_together'
require 'vcr'

require 'webmock/rspec' 
require_relative './support/vcr_setup.rb' 
WebMock.disable_net_connect!(allow_localhost: true)  