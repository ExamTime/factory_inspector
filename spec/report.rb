require 'factory_inspector/report'

describe FactoryInspector::Report do

  let(:foo) { 'FooFactory' }

  context 'on construction' do
    before :all do
      @report = FactoryInspector::Report.new(:foo)
    end

    it 'should be named for the factory' do
      @report.name.should == :foo
    end

    it 'should have recorded zero calls' do
      @report.calls.should == 0
    end

    it 'should have a zero worst time' do
      @report.worst_time.should == 0
    end

    it 'should have a zero total time' do
      @report.total_time.should == 0
    end

    it 'should have recorded no strategies' do
      @report.strategies.should be_empty
    end

    it 'should have a zero time-per-call' do
      @report.time_per_call_in_seconds.should == 0
    end
  end

  context "on update" do
    before :all do
      @report = FactoryInspector::Report.new(:foo)
      @report.update(3, 'build')
      @report.update(5, 'create')
    end

    it 'should have incremented the call count' do
      @report.calls.should == 2
    end

    it 'should have recorded the total time' do
      @report.total_time.should == 8
    end

    it 'should report the time per call' do
      @report.total_time.should == 8
      @report.calls.should == 2
      @report.time_per_call_in_seconds.should == 4
    end

    it 'should report the strategies used' do
      @report.strategies.should == ['build', 'create']
    end
  end

end
