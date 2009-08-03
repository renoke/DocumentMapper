require File.dirname(__FILE__) + '/../../spec_helper'

describe "Configuration" do
  
  before(:each) do
    KeyValueMapper.stub!('require')
    KeyValueMapper.setup(:adapter=>'foobar')
  end
  
  before(:all) do
    KeyValueMapper::Adapters::FoobarAdapter = mock('FoobarAdapter', :new => Class.new)
  end

  it "requires adapter file when setup database" do
    KeyValueMapper.should_receive('require').with(/foobar_adapter/)
    KeyValueMapper.setup(:adapter=>'foobar')
  end
  
  it "returns adapter name" do
    KeyValueMapper.adapter_name.should == 'FoobarAdapter'
  end
  
  it "returns adapter class" do
    KeyValueMapper.adapter_class.should == KeyValueMapper::Adapters::FoobarAdapter
  end
  
  it "returns repository" do
    KeyValueMapper.repository.should be_instance_of(Class)
  end
 
end