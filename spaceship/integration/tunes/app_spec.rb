describe Spaceship do
  describe Spaceship::TunesClient do
    it 'Knows things about apps' do
      single_view = Spaceship.client.apps.find { |a| a['identifier'] == 'tools.fastlane.SingleViewFabricio' }

      expect(single_view).to match_example('integration/fixtures/single_view_app_dev_portal.json')
    end
  end
end
