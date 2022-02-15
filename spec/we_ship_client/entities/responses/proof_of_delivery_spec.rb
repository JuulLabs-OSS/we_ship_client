require 'spec_helper'
require 'we_ship_client/entities/responses/proof_of_delivery'

RSpec.describe WeShipClient::Entities::Responses::ProofOfDelivery do
  describe '.attributes' do
    subject { described_class.new(attributes) }

    let(:attributes) do
      {
        additional_information: nil,
        delivery_date: '2021-04-20T20:50:05',
        signature: 'https://mapss.object.dev.aim.hosting/v3/MAPSS/TRAC/public/445b0bd0-dca1-4ecd-9a2f-a09d750e1d2c/signature.jpg',
        signer_name: 'A SMITH',
        visual: 'https://mapss.object.dev.aim.hosting/v3/MAPSS/TRAC/public/7e3a3970-c38a-462c-adfc-429d411ba089/visual.jpg'
      }
    end

    context 'when required attributes are present' do
      it { is_expected.to be_a(described_class) }
    end

    context 'when attributes are missing' do
      let(:attributes) { {} }

      it { is_expected.to be_a(described_class) }
    end
  end
end
