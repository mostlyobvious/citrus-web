require 'spec_helper'

describe Citrus::Web::BuildConsoleResource do
  ENOUGH_TIME_FOR_FIBER_ENCODER_TO_BLOCK = 0.125

  let(:builds_repository) { fake(:builds_repository) }
  let(:build)             { fake(:build, output: output) { Citrus::Core::Build } }
  let(:output)            { fake(:test_output, read: '') { Citrus::Core::TestOutput } }
  let(:subscribe_console) { fake(:subscribe_console) }

  before do
    stub(injector).builds_repository { builds_repository }
    stub(injector).configuration     { configuration }
    stub(injector).subscribe_console { subscribe_console}
  end

  context 'GET /builds/:build_id/console' do
    context 'successfull' do
      before  { stub(builds_repository).find_by_uuid('1') { build } }
      subject { get '/builds/1/console' }

      specify { expect(subject.code).to                         eq(200) }
      specify { expect(subject.headers['Content-Type']).to      eq('text/event-stream') }
      specify { expect(subject.headers['Connection']).to        eq('keep-alive') }
      specify { expect(subject.headers['Cache-Control']).to     eq('no-cache') }
      specify { expect(subject.headers['Transfer-Encoding']).to eq('identity') }

      it 'should dump existing output data' do
        stub(output).read { 'kaka' }
        expect(subject.body).to eq("data: kaka\n\n")
      end

      it 'should subscribe client for streaming handled by other party' do
        get '/builds/1/console', headers: {'X-Mongrel2-Connection-Id' => 'abc'}
        expect(subscribe_console).to have_received.call('1', 'abc')
      end
    end

    context 'build does not exist' do
      before  { stub(builds_repository).find_by_uuid('2') { raise Citrus::Web::BuildsRepository::NotFound } }
      subject { get '/builds/2/console' }

      specify { expect(subject.code).to                     eq(404) }
      specify { expect(subject.headers['Content-Type']).to  eq('text/html') }
    end
  end

end
