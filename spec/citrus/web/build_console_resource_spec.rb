require 'spec_helper'

describe Citrus::Web::BuildConsoleResource do
  ENOUGH_TIME_FOR_FIBER_ENCODER_TO_BLOCK = 0.125

  let(:builds_repository) { fake(:builds_repository) }
  let(:build)             { fake(:build, output: output) { Citrus::Core::Build } }
  let(:output)            { fake(:file_output, path: file.path) }
  let(:file)              { Tempfile.new('file_output') }

  before { stub(injector).builds_repository { builds_repository } }

  context 'GET /builds/:build_id/console' do
    context 'successfull' do
      before  { stub(builds_repository).find_by_uuid('1') { build } }
      subject { get '/builds/1/console' }

      specify { expect(subject.code).to                     eq(200) }
      specify { expect(subject.headers['Content-Type']).to  eq('text/event-stream') }
      specify { expect(subject.headers['Connection']).to    eq('keep-alive') }
      specify { expect(subject.headers['Cache-Control']).to eq('no-cache') }

      it 'should stream existing output data' do
        file.write('kaka')
        file.flush

        Webmachine::ChunkedBody.new(subject.body).each do |chunk|
          expect(chunk).to eq("c\r\ndata: kaka\n\n\r\n")
          break
        end
      end

      it 'should stream output data as its written' do
        Thread.new do
          sleep(ENOUGH_TIME_FOR_FIBER_ENCODER_TO_BLOCK)
          file.write('kaka')
          file.flush
        end

        Webmachine::ChunkedBody.new(subject.body).each do |chunk|
          expect(chunk).to eq("c\r\ndata: kaka\n\n\r\n")
          break
        end
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
