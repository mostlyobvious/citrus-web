require 'spec_helper'

describe Citrus::Web::Event do

  let(:event)     { described_class.new(kind, timestamp, build) }
  let(:build)     { fake(:build) { Citrus::Core::Build } }
  let(:timestamp) { Time.now }
  let(:kind)      { :build_started }

  specify { expect(event).to respond_to(:kind) }
  specify { expect(event).to respond_to(:timestamp) }
  specify { expect(event).to respond_to(:build) }

end
