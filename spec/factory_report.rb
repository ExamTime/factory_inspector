require 'factory_inspector/factory_report'

describe FactoryInspector::FactoryReport do

  let(:foo) { 'FooFactory' }

  context 'on default construction' do
    before :all do
      @report = FactoryInspector::FactoryReport.new(:foo)
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
  end

end
