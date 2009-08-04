require File.dirname(__FILE__) + '/../../spec_helper'

describe "Configuration" do
  
  
  before(:all) do
    DocumentMapper::Adapters::FoobarAdapter = mock('FoobarAdapter', :new => Class.new)
    DocumentMapper::Adapters::FoobarAdapter.stub!('new').and_return(Class.new)
    DocumentMapper.stub!('require')
    DocumentMapper.setup(:adapter=>'foobar')
  end

  it "requires adapter file when setup database" do
    DocumentMapper.should_receive('require').with(/foobar_adapter/)
    DocumentMapper.setup(:adapter=>'foobar')
  end
  
  it "returns adapter name" do
    DocumentMapper.adapter_name.should == 'FoobarAdapter'
  end
  
  it "returns adapter class" do
    DocumentMapper.adapter_class.should == DocumentMapper::Adapters::FoobarAdapter
  end
  
  it "returns repository" do
    DocumentMapper.repository.should be_instance_of(Class)
  end
 
end