require 'spec_helper'
require 'support/null_serializer'

describe Citrus::Web::ZmqPubsubAdapter::Publisher do

  let(:address)     { 'inproc://' << SecureRandom.hex }
  let(:publisher)   { described_class.new(address, serializer, zmq_context) }
  let(:subscriber)  { zmq_context.socket(ZMQ::SUB).tap { |s|
    s.connect(address)
    s.setsockopt(::ZMQ::LINGER, 100) } }
  let(:zmq_context) { ZMQ::Context.new.tap { |ctx| ctx.send(:remove_finalizer) } }
  let(:serializer)  { NullSerializer.new }

  before  { workaround_for_inproc_bind_first_on_zmq_before_4_0_1 }

  specify { expect(publisher).to respond_to(:publish) }

  it 'should publish data to subscribers' do
    subscriber.setsockopt(ZMQ::SUBSCRIBE, '')
    publisher.publish('subject', 'message')

    subscriber.recv_string(received_msg = '')
    expect(received_msg).to eq('subject message')
  end

  it 'should serialize data before publishing' do
    subscriber.setsockopt(ZMQ::SUBSCRIBE, 'subject')
    mock(serializer).dump('message') { 'serialized_message' }
    publisher.publish('subject', 'message')

    subscriber.recv_string(received_msg = '')
    expect(received_msg).to eq('subject serialized_message')
  end

  def workaround_for_inproc_bind_first_on_zmq_before_4_0_1
    publisher
  end

end
