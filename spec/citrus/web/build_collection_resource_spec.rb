require 'spec_helper'

describe Citrus::Web::BuildCollectionResource do

  let(:builds_repository) { fake(:builds_repository) }
  let(:build)             { fake(:build) { Citrus::Core::Build } }
  let(:json_serializer)   { JSON }
  let(:build_presenter)   { fake(:build_presenter) }
  let(:presented_build)   { {foo: 'bar'} }

  before do
    stub(injector).builds_repository     { builds_repository }
    stub(injector).json_serializer       { json_serializer }
    stub(injector).build_presenter       { build_presenter }
    stub(build_presenter).call(any_args) { presented_build }
  end

  context 'GET /builds' do
    before  { stub(builds_repository).find_all { [build]} }
    subject { get '/builds' }

    specify { expect(subject.code).to                    eq(200) }
    specify { expect(subject.headers['Content-Type']).to eq('application/json') }
    specify { expect(subject.body).to                    eq('[{"foo":"bar"}]') }

    it 'should render each build with build presenter' do
      subject
      expect(build_presenter).to have_received.call(build)
    end

    it 'should serialize build collection' do
      serializer = fake
      stub(injector).json_serializer { serializer }
      subject
      expect(serializer).to have_received.dump([presented_build])
    end
  end

end
