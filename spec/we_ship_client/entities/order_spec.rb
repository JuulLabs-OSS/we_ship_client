require 'spec_helper'
require 'we_ship_client/entities/address'
require 'we_ship_client/entities/order'
require 'we_ship_client/entities/order_item'
require 'we_ship_client/entities/order_items'

RSpec.describe WeShipClient::Entities::Order do
  describe '.attributes' do
    subject { described_class.new(required_attributes) }

    let(:required_attributes) do
      {
        orderNo: 'R00000001',
        orderDate: '2021-04-01',
        shipMethod: '',
        fulfillmentLocation: 'MOW',
        shipToAddress: WeShipClient::Entities::Address.new(
          name: 'John Doe',
          address1: '1 Test Rd',
          city: 'Keller',
          state: 'TX',
          postalCode: '76244',
          country: 'US',
          homePhone: '+15553334444'
        ),
        orderItems: WeShipClient::Entities::OrderItems.new(
          orderItem: [
            WeShipClient::Entities::OrderItem.new(
              productName: 'US - J1 Devices',
              productSKU: 'J1D1846',
              productType: 'TOBG',
              quantity: 1,
              weight: '0.07936641'
            )
          ]
        )
      }
    end

    context 'when required attributes are present' do
      it { is_expected.to be_a(described_class) }
    end

    context 'when orderNo is missing' do
      it 'raises an exception' do
        required_attributes.delete(:orderNo)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Order.new] :orderNo is missing in Hash input')
      end
    end

    context 'when orderDate is missing' do
      it 'raises an exception' do
        required_attributes.delete(:orderDate)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Order.new] :orderDate is missing in Hash input')
      end
    end

    context 'when shipMethod is missing' do
      it 'raises an exception' do
        required_attributes.delete(:shipMethod)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Order.new] :shipMethod is missing in Hash input')
      end
    end

    context 'when fulfillmentLocation is missing' do
      it 'raises an exception' do
        required_attributes.delete(:fulfillmentLocation)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Order.new] :fulfillmentLocation is missing in Hash input')
      end
    end

    context 'when shipToAddress is missing' do
      it 'raises an exception' do
        required_attributes.delete(:shipToAddress)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Order.new] :shipToAddress is missing in Hash input')
      end
    end

    context 'when orderItems is missing' do
      it 'raises an exception' do
        required_attributes.delete(:orderItems)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::Order.new] :orderItems is missing in Hash input')
      end
    end
  end
end
