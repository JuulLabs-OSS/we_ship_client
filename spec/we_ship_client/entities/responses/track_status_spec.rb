require 'spec_helper'
require 'we_ship_client/entities/responses/tracking_item'

RSpec.describe WeShipClient::Entities::Responses::TrackingItem do
  describe '.attributes' do
    subject { described_class.new(required_attributes) }

    let(:required_attributes) do
      {
        location: 'PALATINE IL US',
        message: 'DEPARTURE SCAN',
        status_type: 'I',
        tracking_item_date: 'Wed, 15 Jun 2020 20:48:00 GMT',
        tracking_item_id: 2_496_900,
      }
    end

    context 'when required attributes are present' do
      it { is_expected.to be_a(described_class) }
    end

    context 'when location is empty' do
      it 'accepts empty location' do
        required_attributes[:location] = ''
        is_expected.to be_a(described_class)
      end
    end
  end
end
