require 'spec_helper'
require 'we_ship_client/entities/responses/track_response'
require 'we_ship_client/transforms/tracking_item'

RSpec.describe WeShipClient::Transforms::TrackingItem do
  describe '#call' do
    subject { described_class.new.call(tracking_item: tracking_item, state: state) }
    let(:state) { 'CA' }

    context 'when it is a regular and valid message' do
      let(:tracking_item) do
        WeShipClient::Entities::Responses::TrackingItem.new(
          location: 'test',
          message: 'Signed by John',
          status_type: 'D',
          tracking_item_date: 'Mon 26 Apr 2021 19:25:21 GMT',
          tracking_item_id: 1
        )
      end

      it 'does not modify the any values' do
        subject
        expect(tracking_item.status_type).to eq('D')
        expect(tracking_item.message).to eq('Signed by John')
        expect(tracking_item.tracking_item_date).to eq('2021-04-27T02:25:21+00:00')
      end
    end

    context 'when message is signed by 85' do
      let(:tracking_item) do
        WeShipClient::Entities::Responses::TrackingItem.new(
          location: 'test',
          message: 'Delivered, Signed by 85',
          status_type: 'D',
          tracking_item_date: 'Mon 26 Apr 2021 19:28:21 GMT',
          tracking_item_id: 2
        )
      end

      it 'modifies the values' do
        subject
        expect(tracking_item.status_type).to eq('X')
        expect(tracking_item.message).to eq(WeShipClient::Transforms::TrackingItem::DELIVERY_ATTEMPTED_MESSAGE)
      end
    end

    context 'when message has lost' do
      let(:tracking_item) do
        WeShipClient::Entities::Responses::TrackingItem.new(
          location: 'test',
          message: 'Delivered, Signed by LOST/MISSING',
          status_type: 'D',
          tracking_item_date: 'Mon 13 Oct 2021 22:28:25 GMT',
          tracking_item_id: 2
        )
      end

      it 'modifies the values' do
        subject
        expect(tracking_item.status_type).to eq('X')
        expect(tracking_item.message).to eq(WeShipClient::Transforms::TrackingItem::DELIVERY_ATTEMPTED_MESSAGE)
      end
    end

    context 'when message has undeliverable' do
      let(:tracking_item) do
        WeShipClient::Entities::Responses::TrackingItem.new(
          location: 'test',
          message: 'Delivered, Signed by REFAB# ZY05KZ8M  UNDELIVERABLE',
          status_type: 'D',
          tracking_item_date: 'Mon 13 Oct 2021 23:28:25 GMT',
          tracking_item_id: 2
        )
      end

      it 'modifies the values' do
        subject
        expect(tracking_item.status_type).to eq('X')
        expect(tracking_item.message).to eq(WeShipClient::Transforms::TrackingItem::DELIVERY_ATTEMPTED_MESSAGE)
      end
    end

    context 'handling for message 48' do
      let(:tracking_item) do
        WeShipClient::Entities::Responses::TrackingItem.new(
          location: 'test',
          message: '48',
          status_type: 'X',
          tracking_item_date: 'Mon 26 Apr 2021 19:28:21 GMT',
          tracking_item_id: 2
        )
      end

      it 'modifies the values' do
        subject
        expect(tracking_item.status_type).to eq('X')
        expect(tracking_item.message).to eq(WeShipClient::Transforms::TrackingItem::DELIVERY_ATTEMPTED_MESSAGE)
      end

      context 'when 48 is a part of another message' do
        let(:tracking_item) do
          WeShipClient::Entities::Responses::TrackingItem.new(
            location: 'test',
            message: 'Signed by user 48',
            status_type: 'D',
            tracking_item_date: 'Mon 26 Apr 2021 19:28:21 GMT',
            tracking_item_id: 2
          )
        end

        it 'does not modify the values' do
          subject
          expect(tracking_item.status_type).to eq('D')
          expect(tracking_item.message).to eq('Signed by user 48')
        end
      end
    end

    context 'when message has No One Avail Sig Required' do
      let(:tracking_item) do
        WeShipClient::Entities::Responses::TrackingItem.new(
          location: 'test',
          message: 'No One Avail Sig Required 2nd Attempt',
          status_type: 'I',
          tracking_item_date: 'Mon 26 Apr 2021 19:28:21 GMT',
          tracking_item_id: 2
        )
      end

      it 'modifies the values' do
        subject
        expect(tracking_item.status_type).to eq('X')
      end
    end

    context 'when message with duplicates' do
      let(:tracking_item) do
        WeShipClient::Entities::Responses::TrackingItem.new(
          location: 'test',
          message: 'No One Avail Sig Required 2nd Attempt----No One Avail Sig Required 2nd Attempt',
          status_type: 'X',
          tracking_item_date: 'Mon 26 Apr 2021 22:28:21 GMT',
          tracking_item_id: 4
        )
      end

      it 'modifies the values' do
        subject
        expect(tracking_item.message).to eq('No One Avail Sig Required 2nd Attempt')
      end

      context 'when a different delimiter' do
        let(:tracking_item) do
          WeShipClient::Entities::Responses::TrackingItem.new(
            location: 'test',
            message: 'Bad Address---Bad Address',
            status_type: 'X',
            tracking_item_date: 'Mon 26 Apr 2021 22:28:21 GMT',
            tracking_item_id: 4
          )
        end

        it 'does not modify the values' do
          subject
          expect(tracking_item.message).to eq('Bad Address---Bad Address')
        end
      end
    end

    context 'when message with Driver: in the message' do
      let(:tracking_item) do
        WeShipClient::Entities::Responses::TrackingItem.new(
          location: 'test',
          message: 'Driver: M289 Manifest: 1742237 Job[1] JobStatus N --> A DriverPay=True',
          status_type: 'I',
          tracking_item_date: 'Mon 25 May 2021 22:28:21 GMT',
          tracking_item_id: 5
        )
      end

      it 'modifies the values' do
        subject
        expect(tracking_item.message).to eq('With driver')
      end
    end

    context 'when Delivered, Signed by RETURN in the message' do
      let(:tracking_item) do
        WeShipClient::Entities::Responses::TrackingItem.new(
          location: 'test',
          message: 'Delivered, Signed by RETURN',
          status_type: 'D',
          tracking_item_date: 'Mon 9 Aug 2021 19:28:21 GMT',
          tracking_item_id: 5
        )
      end

      it 'modifies the values' do
        subject
        expect(tracking_item.message).to eq('Return to Sender')
        expect(tracking_item.status_type).to eq('R')
      end
    end

    context 'when out for delivery message with exception status' do
      let(:tracking_item) do
        WeShipClient::Entities::Responses::TrackingItem.new(
          location: 'test',
          message: 'Out for Delivery',
          status_type: 'X',
          tracking_item_date: 'Fri 19 Nov 2021 19:28:21 GMT',
          tracking_item_id: 2
        )
      end

      it 'modifies the values' do
        subject
        expect(tracking_item.status_type).to eq('I')
      end
    end

    context 'when Delivered, Signed by 3 attempts in the message' do
      let(:tracking_item) do
        WeShipClient::Entities::Responses::TrackingItem.new(
          location: 'test',
          message: 'Delivered, Signed by 3 attempts',
          status_type: 'D',
          tracking_item_date: 'Mon 9 Aug 2021 18:28:21 GMT',
          tracking_item_id: 5
        )
      end

      it 'modifies the values' do
        subject
        expect(tracking_item.message).to eq('Return to Sender')
        expect(tracking_item.status_type).to eq('R')
      end
    end

    context 'when Delivered, Signed by RTS in the message' do
      let(:tracking_item) do
        WeShipClient::Entities::Responses::TrackingItem.new(
          location: 'test',
          message: 'Delivered, Signed by RTS 3 attempts',
          status_type: 'D',
          tracking_item_date: 'Mon 9 Aug 2021 18:28:21 GMT',
          tracking_item_id: 5
        )
      end

      it 'modifies the values' do
        subject
        expect(tracking_item.message).to eq('Return to Sender')
        expect(tracking_item.status_type).to eq('R')
      end
    end

    context 'when message is for order in CA' do
      let(:tracking_item) do
        WeShipClient::Entities::Responses::TrackingItem.new(
          location: 'test',
          message: 'Signed by John',
          status_type: 'P',
          tracking_item_date: 'Fri 28 May 2021 10:25:01 GMT',
          tracking_item_id: 1
        )
      end

      it 'modifies the date to UTC' do
        subject
        expect(tracking_item.tracking_item_date).to eq('2021-05-28T17:25:01+00:00')
      end
    end

    context 'when message is for order in TX' do
      let(:state) { 'TX' }
      let(:tracking_item) do
        WeShipClient::Entities::Responses::TrackingItem.new(
          location: 'test',
          message: 'Signed by Kevin',
          status_type: 'I',
          tracking_item_date: 'Fri 28 May 2021 10:25:01 GMT',
          tracking_item_id: 1
        )
      end

      it 'modifies the date to UTC' do
        subject
        expect(tracking_item.tracking_item_date).to eq('2021-05-28T15:25:01+00:00')
      end
    end

    context 'when message is for order in MA' do
      let(:state) { 'MA' }
      let(:tracking_item) do
        WeShipClient::Entities::Responses::TrackingItem.new(
          location: 'test',
          message: 'Signed by Doug',
          status_type: 'I',
          tracking_item_date: 'Fri 28 May 2021 10:25:01 GMT',
          tracking_item_id: 1
        )
      end

      it 'modifies the date to UTC' do
        subject
        expect(tracking_item.tracking_item_date).to eq('2021-05-28T14:25:01+00:00')
      end
    end

    context 'when message is for order in AZ' do
      let(:state) { 'AZ' }
      let(:tracking_item) do
        WeShipClient::Entities::Responses::TrackingItem.new(
          location: 'test',
          message: 'Signed by Doug',
          status_type: 'I',
          tracking_item_date: 'Fri 28 May 2021 10:25:01 GMT',
          tracking_item_id: 1
        )
      end

      it 'modifies the date to UTC' do
        subject
        expect(tracking_item.tracking_item_date).to eq('2021-05-28T16:25:01+00:00')
      end
    end

    context 'when message lacks tracking_item_date' do
      let(:tracking_item) do
        WeShipClient::Entities::Responses::TrackingItem.new(
          location: 'test',
          message: 'Signed by John',
          status_type: 'D',
          tracking_item_id: 1
        )
      end

      it 'does not modify the any values' do
        subject
        expect(tracking_item.status_type).to eq('D')
        expect(tracking_item.message).to eq('Signed by John')
        expect(tracking_item.tracking_item_date).to be_nil
      end
    end

    context 'when message has Electronically Transmitted with exception' do
      let(:tracking_item) do
        WeShipClient::Entities::Responses::TrackingItem.new(
          location: 'test',
          message: 'Electronically Transmitted',
          status_type: 'X',
          tracking_item_id: 1
        )
      end

      it 'modifies the values' do
        subject
        expect(tracking_item.status_type).to eq('M')
      end
    end
  end
end
