require 'spec_helper'

RSpec.describe WeShipClient::Interactors::ProcessOrders do
  describe '#call' do
    let(:auth_token) do
      VCR.use_cassette('token/success') do
        WeShipClient::TokenClient.new.generate_access_token
      end
    end
    let(:order_one) do
      WeShipClient::Entities::Order.new(
        orderNo: 'TESTR00000001',
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
              weight: '0.08'
            )
          ]
        )
      )
    end
    let(:order_two) do
      WeShipClient::Entities::Order.new(
        orderNo: 'TESTR00000002',
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
              weight: '0.081'
            )
          ]
        )
      )
    end
    let(:process_orders_request) do
      WeShipClient::Entities::ProcessOrdersRequest.new(
        allowDuplicates: 'Y',
        clientCode: ENV['WE_SHIP_CUSTOMER_CODE'],
        formatVersion: ENV['WE_SHIP_FORMAT_VERSION'],
        order: [
          order_one,
          order_two
        ]
      )
    end
    let(:response) do
      double(
        :response,
        body: '{ "response": { "ordersHeldInGateway": [], "rejectedorders": { "order": []}}}',
        status: 200
      )
    end

    subject do
      described_class.new(
        auth_token: auth_token,
        process_orders_request: process_orders_request
      ).call
    end

    it 'handles request to WeShip' do
      expect_any_instance_of(LoogiHttp::Connection).to receive(:post).with(
        "#{ENV['WE_SHIP_BASE_URL']}/process_orders",
        data: process_orders_request.to_h,
        headers: { Authorization: "JWT #{auth_token}" }
      ).and_return(response)

      subject
    end

    it 'returns accepted and rejected order response' do
      VCR.use_cassette('interactors/process_orders/mixed_results') do
        expect(subject).to be_a WeShipClient::Entities::Responses::ProcessOrders
        expect(subject.ordersHeldInGateway.size).to eq 1
        expect(subject.rejectedorders.order.size).to eq 1
      end
    end

    context 'when sending only an order with correct details' do
      let(:process_orders_request) do
        WeShipClient::Entities::ProcessOrdersRequest.new(
          allowDuplicates: 'Y',
          clientCode: ENV['WE_SHIP_CUSTOMER_CODE'],
          formatVersion: ENV['WE_SHIP_FORMAT_VERSION'],
          order: [
            order_one
          ]
        )
      end

      it 'returns only accepted orders' do
        VCR.use_cassette('interactors/process_orders/only_accepted_results') do
          expect(subject).to be_a WeShipClient::Entities::Responses::ProcessOrders
          expect(subject.ordersHeldInGateway.size).to eq 1
          expect(subject.rejectedorders.order.size).to eq 0
        end
      end
    end

    context 'when sending only an order with incorrect weight' do
      let(:process_orders_request) do
        WeShipClient::Entities::ProcessOrdersRequest.new(
          allowDuplicates: 'Y',
          clientCode: ENV['WE_SHIP_CUSTOMER_CODE'],
          formatVersion: ENV['WE_SHIP_FORMAT_VERSION'],
          order: [
            order_two
          ]
        )
      end

      it 'returns only rejected orders' do
        VCR.use_cassette('interactors/process_orders/only_rejected_results') do
          expect(subject).to be_a WeShipClient::Entities::Responses::ProcessOrders
          expect(subject.ordersHeldInGateway).to be_nil
          expect(subject.rejectedorders.order.size).to eq 1
        end
      end
    end
  end
end
