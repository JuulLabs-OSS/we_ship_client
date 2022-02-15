require 'spec_helper'
require 'webmock/rspec'

RSpec.describe WeShipClient::Interactors::GetTracking do
  let(:customer_code) { [ENV['WE_SHIP_CUSTOMER_CODE']] }
  let(:request) do
    WeShipClient::Entities::TrackRequest.new(customer_code: customer_code)
  end

  describe '#call' do
    subject do
      described_class.new(auth_token: auth_token, track_request: request).call
    end

    let(:auth_token) do
      VCR.use_cassette('token/success') do
        WeShipClient::TokenClient.new.generate_access_token
      end
    end
    let(:cassette_name) { nil }
    let(:stubbed_response) { nil }

    around do |example|
      VCR.use_cassette(cassette_name) do
        if stubbed_response
          stub_request(
            :post,
            "#{ENV['WE_SHIP_BASE_URL']}/track"
          ).to_return(body: stubbed_response)
        end
        example.run
      end
    end

    context 'when API call is successful' do
      let(:cassette_name) { 'interactors/get_tracking/success' }

      it { is_expected.to be_a(WeShipClient::Entities::Responses::TrackResponse) }

      context 'when API call contains a specific response that must be modified' do

        let(:stubbed_response) do
          File.read('spec/fixtures/responses/get_tracking/to_be_modified.json')
        end

        it 'message and status_type are modified' do
          expect(subject.results.first.tracking_items.last).to have_attributes(
            status_type: 'X',
            message: 'Delivery attempt was made'
          )
        end
      end

      context 'when API call is a successful with null location' do
        let(:stubbed_response) do
          File.read('spec/fixtures/responses/get_tracking/with_null_location.json')
        end

        it { is_expected.to be_a(WeShipClient::Entities::Responses::TrackResponse) }
      end

      context 'when API call is a successful with null tracking_item_date & tracking_item_id' do
        let(:stubbed_response) do
          File.read('spec/fixtures/responses/get_tracking/with_null_tracking_item_date_and_id.json')
        end

        it { is_expected.to be_a(WeShipClient::Entities::Responses::TrackResponse) }

        it 'filters out tracking items without tracking_item_date or tracking_item_id' do
          tracking_items = subject.results.flat_map(&:tracking_items).compact

          tracking_items.each do |item|
            expect(item.tracking_item_date.present? || item.tracking_item_id.present?).to be_truthy
          end
        end
      end

      context 'when API call is a successful with null message' do
        let(:stubbed_response) do
          File.read('spec/fixtures/responses/get_tracking/with_null_message.json')
        end

        it { is_expected.to be_a(WeShipClient::Entities::Responses::TrackResponse) }

        it 'filters out tracking items without message' do
          tracking_items = subject.results.flat_map(&:tracking_items).compact

          tracking_items.each do |item|
            expect(item.message.present?).to be_truthy
          end
        end
      end

      context 'when API call is a successful with bad exception message' do
        let(:stubbed_response) do
          File.read('spec/fixtures/responses/get_tracking/with_bad_exception_message.json')
        end

        it { is_expected.to be_a(WeShipClient::Entities::Responses::TrackResponse) }

        it 'filters out tracking items with bad exception message' do
          tracking_items = subject.results.flat_map(&:tracking_items).compact
          tracking_items.each do |item|
            expect(item.status_type).to_not eq('X')
          end
        end
      end
    end

    context 'when API call is not successful' do
      context 'when JWT token is invalid' do
        let(:auth_token) { 'invalid-jwt' }
        let(:cassette_name) { 'interactors/get_tracking/invalid_jwt' }

        it { expect { subject }.to raise_error(WeShipClient::Exceptions::AuthenticationError) }
      end

      context 'when there is a different error' do
        let(:customer_code) { ['XXXX'] }
        let(:cassette_name) { 'interactors/get_tracking/invalid_customer_code' }
        let(:request) do
          WeShipClient::Entities::TrackRequest.new(order_id: ['123789'], customer_code: customer_code)
        end

        it { expect { subject }.to raise_error(WeShipClient::Exceptions::ServerError) }
      end
    end
  end
end
