require 'spec_helper'
require 'we_ship_client/entities/address'
require 'we_ship_client/entities/order'
require 'we_ship_client/entities/order_item'
require 'we_ship_client/entities/order_items'
require 'we_ship_client/entities/process_orders_request'

RSpec.describe WeShipClient::Entities::ProcessOrdersRequest do
  describe '.attributes' do
    subject { described_class.new(required_attributes) }

    let(:required_attributes) do
      {
        allowDuplicates: 'N',
        clientCode: ENV['WE_SHIP_CUSTOMER_CODE'],
        formatVersion: ENV['WE_SHIP_FORMAT_VERSION'],
        order: [
          WeShipClient::Entities::Order.new(
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
          )
        ]
      }
    end

    context 'when required attributes are present' do
      it { is_expected.to be_a(described_class) }
    end

    context 'when order is missing' do
      it 'raises an exception' do
        required_attributes.delete(:order)

        expect { subject }.to raise_error(Dry::Struct::Error, '[WeShipClient::Entities::ProcessOrdersRequest.new] :order is missing in Hash input')
      end
    end
  end
end
