describe FactoryInspector::FactoryReport do

  let (:foo) { 'Foo' }

  it "should have a name" do
    report = FactoryInspector::FactoryReport.new(foo)
    report.name.should == foo
  end
end
