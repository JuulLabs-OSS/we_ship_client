require 'spec_helper'
require 'we_ship_client/token_client'

RSpec.describe WeShipClient::TokenClient do
  describe '#generate_access_token' do
    subject { described_class.new.generate_access_token }

    it 'handles request to WeShip' do
      expect_any_instance_of(LoogiHttp::Connection).to receive(:post).with(
        "#{ENV['WE_SHIP_BASE_URL']}/token",
        data: {
          username: ENV['WE_SHIP_USERNAME'],
          password: ENV['WE_SHIP_PASSWORD'],
        }
      ).and_return(double(:response, body: '{ "access_token": "token" }', status: 200))

      expect(subject).to eq 'token'
    end

    it 'returns a JWT access token' do
      VCR.use_cassette('token/success') do
        expect(subject).to match(/.{150,}\..{40,}/)
      end
    end

    context 'when the response is an server failure' do
      before do
        allow_any_instance_of(LoogiHttp::Connection).to receive(:post).and_return(
          double(:response, body: '', status: 500)
        )
      end

      it 'raises a server error' do
        expect { subject }.to raise_error(WeShipClient::Exceptions::ServerError)
      end

      it 'handles server error' do
        expect_any_instance_of(LoogiHttp::Connection).to receive(:post).with(
          "#{ENV['WE_SHIP_BASE_URL']}/token",
          data: {
            username: ENV['WE_SHIP_USERNAME'],
            password: ENV['WE_SHIP_PASSWORD'],
          }
        ).and_return(double(:response, body: '{ "error": "Bad Request" }', status: 500))

        expect { subject }.to raise_error(WeShipClient::Exceptions::ServerError)
      end
    end

    context 'when the response is an unauthorized failure' do
      before do
        stub_env 'WE_SHIP_PASSWORD', 'fake'
      end

      it 'raises an authentication error' do
        VCR.use_cassette('token/unauthorized') do
          expect { subject }.to raise_error(WeShipClient::Exceptions::AuthenticationError)
        end
      end

      it 'handles authentication error' do
        expect_any_instance_of(LoogiHttp::Connection).to receive(:post).with(
          "#{ENV['WE_SHIP_BASE_URL']}/token",
          data: {
            username: ENV['WE_SHIP_USERNAME'],
            password: ENV['WE_SHIP_PASSWORD'],
          }
        ).and_return(double(:response, body: '{ "error": "Bad Request" }', status: 401))

        expect { subject }.to raise_error(WeShipClient::Exceptions::AuthenticationError)
      end
    end
  end
end
