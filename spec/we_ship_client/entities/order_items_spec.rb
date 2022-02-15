require 'spec_helper'
require 'we_ship_client/entities/order_item'
require 'we_ship_client/entities/order_items'

RSpec.describe WeShipClient::Entities::OrderItems do
  describe '.attributes' do
    subject { described_class.new(required_attributes) }

    let(:required_attributes) do
      {
        orderItem: [
          WeShipClient::Entities::OrderItem.new(
            productName: 'US - J1 Devices',
            productSKU: 'J1D1846',
            productType: 'TOBG',
            quantity: 1,
            weight: '0.07936641'
          )
        ]
      }
    end

    context 'when required attributes are present' do
      it { is_expected.to be_a(described_class) }
    end

    context 'when orderItem is missing' do
      it 'raises an exception' do
        required_attributes.delete(:orderItem)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::OrderItems.new] :orderItem is missing in Hash input')
      end
    end
  end
end
