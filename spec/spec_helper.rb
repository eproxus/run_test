require 'rspec'
require 'run_test'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter = 'documentation'
end