require 'spec_helper'

describe Citrus::Web::ThreadedBuildExecutor do

  let(:build_executor) { described_class.new(execute_build, build_queue) }
  let(:build_queue)    { fake(:queue) }
  let(:execute_build)  { fake(:execute_build) { Citrus::Core::ExecuteBuild } }
  let(:build)          { fake(:build)         { Citrus::Core::Build } }

  context '#start' do
    it 'should execute dequeued build' do
      pending 'apparently bogus has issues with threads [failing, infinite loop]'

      build_queue.push(build)
      build_executor.start
      expect(execute_build).to have_received.start(build)
    end

    it 'should start given number of workers' do
      pending 'apparently bogus has issues with threads [passing, slowing down suite]'

      build_executor.start(2)
      expect(build_executor.workers).to have(2).items
    end
  end

end
