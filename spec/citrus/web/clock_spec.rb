require 'spec_helper'

describe Citrus::Web::Clock do

  let(:clock) { described_class.new }

  specify { expect(clock).to          respond_to(:now) }
  specify { expect(clock.now).to      be_kind_of(Time) }
  specify { expect(clock.now.zone).to eq('UTC') }

end
