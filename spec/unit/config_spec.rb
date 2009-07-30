require File.dirname(__FILE__) + '/../spec_helper'

describe "Configuration" do
  
  before(:each) do
    FlatDoc.stub!('require')
    FlatDoc.setup(:adapter=>'foobar')
  end
  
  before(:all) do
    FlatDoc::Adapters::FoobarAdapter = mock('FoobarAdapter', :new => Class.new)
  end

  it "requires adapter file when setup database" do
    FlatDoc.should_receive('require').with(/foobar_adapter/)
    FlatDoc.setup(:adapter=>'foobar')
  end
  
  it "returns adapter name" do
    FlatDoc.adapter_name.should == 'FoobarAdapter'
  end
  
  it "returns adapter class" do
    FlatDoc.adapter_class.should == FlatDoc::Adapters::FoobarAdapter
  end
  
  it "returns repository" do
    FlatDoc.repository.should be_instance_of(Class)
  end
 
end