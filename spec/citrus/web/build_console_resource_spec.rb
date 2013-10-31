require 'spec_helper'

describe Citrus::Web::BuildConsoleResource do

  let(:builds_repository) { fake(:builds_repository) }
  let(:build)             { fake(:build, output: output) { Citrus::Core::Build } }
  let(:output)            { fake(:test_output, read: '') { Citrus::Core::TestOutput } }
  let(:subscribe_client)  { fake(:subscribe_client) }

  before do
    stub(injector).builds_repository { builds_repository }
    stub(injector).subscribe_client  { subscribe_client  }
  end

  context 'GET /builds/:build_id/console' do
    context 'successfull' do
      before  { stub(builds_repository).find_by_uuid('1') { build } }
      subject { get '/builds/1/console' }

      specify { expect(subject.code).to                             eq(200) }
      specify { expect(subject.headers['Content-Type']).to          eq('text/event-stream') }
      specify { expect(subject.headers['Connection']).to            eq('keep-alive') }
      specify { expect(subject.headers['Cache-Control']).to         eq('no-cache') }
      specify { expect(subject.headers['Transfer-Encoding']).to_not eq('chunked') }
      specify { expect(subject.headers).to_not                      have_key('Content-Lenght') }

      it 'should subscribe client for streaming handled by other party' do
        get '/builds/1/console', headers: {'X-Mongrel2-Connection-Id' => '1337'}
        expect(subscribe_client).to have_received.call('1337', '1')
      end

      it 'should dump existing output data' do
        stub(output).read { 'kaka' }
        expect(subject.body).to eq("data: kaka\n\n")
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
