require 'spaceship'
describe 'Dev Portal' do
  before(:all) do
    Spaceship.login('fabric-devtools@twitter.com')
  end

  it 'Knows things about Apps' do
    single_view = Spaceship.client.apps.select { |a| a['identifier'] == 'tools.fastlane.SingleViewFabricio' }.first

    expect(single_view).to match_example('integration/fixtures/single_view_app_dev_portal.json')
  end
end
