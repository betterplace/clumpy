require 'simplecov'

SimpleCov.adapters.define 'gem' do
  add_filter '/spec/'
  add_filter '/autotest/'
  add_group 'Libraries', '/lib/'
end
SimpleCov.start 'gem'

require 'clumpy'
require 'ostruct'

RSpec.configure do |config|
  config.color_enabled = true
end
