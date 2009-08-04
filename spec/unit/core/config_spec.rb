require File.dirname(__FILE__) + '/../../spec_helper'

describe DocumentMapper::Config do
  
  
  before(:all) do    
    class DocumentMapper::Adapters::FoobarAdapter
      attr_accessor :foo
      def initialize(hash={})
        @foo = hash[:foo]
      end
    end
    
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
    @it = DocumentMapper.repository
    @it.should be_instance_of(DocumentMapper::Adapters::FoobarAdapter)
    @it.foo.should be_nil
  end
  
  it "returns a new repository if options is given" do
    @it = DocumentMapper.repository(:foo=>'bar')
    @it.should be_instance_of(DocumentMapper::Adapters::FoobarAdapter)
    @it.foo.should == 'bar'
  end
 
end