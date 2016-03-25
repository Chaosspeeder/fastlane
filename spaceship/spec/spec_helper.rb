require 'spaceship'
require 'plist'
require 'pry'

# This module is only used to check the environment is currently a testing env
module SpecHelper
end

if ENV['INTEGRATION']
  require 'integration_spec_helper'
else
  require 'unit_spec_helper'
end
