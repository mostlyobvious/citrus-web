require 'spec_helper'

describe Citrus::Web::SubscribeClient do

  let(:subscribe_client)         { described_class.new(subscriptions_repository) }
  let(:subscriptions_repository) { fake(:subscriptions_repository) }
  let(:subscription)             { fake(:subscription) }
  let(:client_id)                { '1337' }
  let(:subject)                  { 'dummy' }

  context '#call' do
    before do
      stub(Citrus::Web::Subscription).new(client_id, subject) { subscription }
      subscribe_client.(client_id, subject)
    end

    specify { expect(subscriptions_repository).to have_received.create_subscription(subscription) }
  end

end
