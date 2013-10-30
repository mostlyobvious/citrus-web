require 'spec_helper'

describe Citrus::Web::SubscriptionsRepository do

  let(:subscriptions_repository) { described_class.new }
  let(:subscription)             { Citrus::Web::Subscription.new('1337', 'dummy') }

  specify { expect(subscriptions_repository).to respond_to(:subscriptions_count) }

  it 'should create subscriptions' do
    expect { subscriptions_repository.create_subscription(subscription) }.to change { subscriptions_repository.subscriptions_count }.by(1)
  end

  it 'should remove subscriptions' do
    subscriptions_repository.create_subscription(subscription)
    expect { subscriptions_repository.remove_subscription(subscription) }.to change { subscriptions_repository.subscriptions_count }.by(-1)
  end

  it 'should find all subscriptions by subject' do
    subscriptions_repository.create_subscription(subscription)
    subscriptions_repository.create_subscription(Citrus::Web::Subscription.new('1337', 'foobar'))
    expect(subscriptions_repository.find_all_by_subject('dummy')).to eq([subscription])
  end

  it 'should find subscription by client id' do
    subscriptions_repository.create_subscription(subscription)
    subscriptions_repository.create_subscription(Citrus::Web::Subscription.new('007', 'foobar'))
    expect(subscriptions_repository.find_all_by_client_id('1337')).to eq([subscription])
  end

end
