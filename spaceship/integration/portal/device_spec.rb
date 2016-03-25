describe Spaceship do
  describe Spaceship::Portal do
    describe Spaceship::Portal::Device do
      let(:device) { Spaceship::Portal.device }

      before(:all) do
        @devices = Spaceship::Portal.device.all
      end

      it 'finds devices on the portal' do
        expect(@devices).to_not be_empty
      end

      it 'fetched devices have reasonable data' do
        device = @devices.first

        expect(device.id).to match_apple_ten_char_id
        expect(device.name).to_not be_empty
        expect(device.udid).to match_a_udid
        expect(device.platform).to eq('ios')
        expect(device.status).to_not be_nil
        expect(device.device_type).to_not be_nil
      end

      # it 'certificate creation and revokation work' do
      #   # Create a new certificate signing request
      #   csr, _ = certificate.create_certificate_signing_request

      #   # Use the signing request to create a new distribution certificate
      #   created_cert = certificate.production.create!(csr: csr)
      #   created_cert_id = created_cert.id

      #   expect(created_cert_id).to match(/^\w{10}$/)
      #   expect(created_cert.status).to eq("Issued")

      #   created_cert.revoke!

      #   # re-fetch certificates to see if this one we just made has been revoked
      #   certs = certificate.all

      #   expect(certs.any? { |cert| cert.id == created_cert_id }).to be(false)
      # end

      # it 'downloads and returns an actual Certificate object' do
      #   x509_cert = @certificates.first.download

      #   expect(x509_cert).to be_kind_of(OpenSSL::X509::Certificate)
      #   expect(x509_cert.issuer.to_s).to match(/Apple Inc\./)
      # end
    end
  end
end
