require File.dirname(__FILE__) + '/../spec_helper'

describe "Configuration" do
  
  before(:each) do
    Flat.stub!('require')
    Flat.setup(:adapter=>'foobar')
  end
  
  before(:all) do
    Flat::Adapters::FoobarAdapter = mock('FoobarAdapter', :new => Class.new)
  end

  it "requires adapter file when setup database" do
    Flat.should_receive('require').with(/foobar_adapter/)
    Flat.setup(:adapter=>'foobar')
  end
  
  it "returns adapter name" do
    Flat.adapter_name.should == 'FoobarAdapter'
  end
  
  it "returns adapter class" do
    Flat.adapter_class.should == Flat::Adapters::FoobarAdapter
  end
  
  it "returns repository" do
    Flat.repository.should be_instance_of(Class)
  end
 
end