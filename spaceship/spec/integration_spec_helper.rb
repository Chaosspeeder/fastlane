require './integration/example_matcher.rb'

RSpec.configure do |config|
  config.pattern = './integration/**/*_spec.rb'

  config.before(:all) do
    apple_id = ENV['SPACESHIP_INTEGRATION_TEST_APPLE_ID']
    password = ENV['SPACESHIP_INTEGRATION_TEST_APPLE_PASSWORD']

    unless apple_id && password
      raise "You must set SPACESHIP_INTEGRATION_TEST_APPLE_ID and SPACESHIP_INTEGRATION_TEST_APPLE_PASSWORD"
    end
    Spaceship::Portal.login(apple_id, password)
    Spaceship::Tunes.login(apple_id, password)
  end
end
