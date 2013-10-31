require 'spec_helper'

describe Citrus::Web::BuildResource do

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

  context 'GET /builds/:build_id' do
    context 'successful' do
      before  { stub(builds_repository).find_by_uuid('1') { build } }
      subject { get '/builds/1' }

      specify { expect(subject.code).to                    eq(200) }
      specify { expect(subject.headers['Content-Type']).to eq('application/json') }
      specify { expect(subject.body).to                    eq('{"foo":"bar"}') }

      it 'should render build with build presenter' do
        subject
        expect(build_presenter).to have_received.call(build)
      end

      it 'should serialize build' do
        serializer = fake
        stub(injector).json_serializer { serializer }
        subject
        expect(serializer).to have_received.dump(presented_build)
      end
    end

    context 'build does not exist' do
      before  { stub(builds_repository).find_by_uuid('2') { raise Citrus::Web::BuildsRepository::NotFound } }
      subject { get '/builds/2' }

      specify { expect(subject.code).to                     eq(404) }
      specify { expect(subject.headers['Content-Type']).to  eq('text/html') }
    end
  end

end
