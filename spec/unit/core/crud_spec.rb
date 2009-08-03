require File.dirname(__FILE__) + '/../../spec_helper'
include MockDocument


describe DocumentMapper::Crud::ClassMethods do

  before(:each) do
    setup_class
  end
  
  it "get a Document" do
    @dbclass.should_receive(:get).with(1).and_return('foo'=>'bar', 'id'=>1)
    it = @class.get(1)
    it.should == {'foo'=>'bar', 'id'=>1}
    it.should be_kind_of(DocumentMapper::Base)
  end
  
  it "return nil if it couldn't get a Document" do
    @dbclass.should_receive(:get).with(1).and_return(nil)
    @class.get(1).should be_nil
  end
  
  it "return an error if it couldn't get! a Document" do
    @dbclass.should_receive(:get).with(1).and_return(nil)
    lambda {@class.get!(1)}.should raise_error
  end
  
  it "create a Document" do
    instance = DocumentMapper::Base.new('foo'=>'bar')
    instance.stub!(:db).and_return(@dbclass)
    @dbclass.should_receive(:create).and_return(1)
    @class.should_receive(:new).with('foo'=>'bar').and_return(instance)
    it = @class.create('foo'=>'bar')
    it.should be_kind_of(DocumentMapper::Base)
  end
  
  it "find all Documents" do
    @dbclass.should_receive(:read_all).once.and_return([{:key=>'test1'},{:key=>'test2'}])
    it = @class.all
    it.should be_kind_of(Array)
    it.first.should be_kind_of(DocumentMapper::Base)
  end
  
  it "first first Document" do
    @dbclass.should_receive(:read_one).and_return({:foo=>'bar', :id=>1})
    it = @class.first
    it.should be_kind_of(DocumentMapper::Base)
    it.foo.should == 'bar'
  end
  
end




describe DocumentMapper::Crud::InstanceMethods do
  
  before(:each) do
    setup_instance
  end
  
  it "instantiate a new Document" do
    @it = DocumentMapper::Base.new(:foo => 'bar').should == {'foo' => 'bar'}
  end
  
  it "saves and creates a Document" do
    @db.should_receive(:create).and_return(1)
    @it = DocumentMapper::Base.new(:foo => 'bar')
    @it.stub!(:db).and_return(@db)
    @it.save
    @it.should be_kind_of(DocumentMapper::Base)
    @it.should_not be_new_record
  end
  
  it "saves and updates Document" do
    @mash.merge!(:foo=>'bar', :id=>1)
    @db.should_receive(:update).and_return({'foo'=>'bar', 'id'=>1})
    @mash.stub!(:id).and_return(1)
    @mash.stub!(:new_record?).and_return(false)
    @mash.save.should == {'foo'=>'bar', 'id'=>1}
  end
  
  it "destroy a Document" do
    @mash.merge!(:foo=>'bar', :id=>1)
    @db.should_receive(:delete).and_return({'foo' => 'bar', 'id'=>1})
    @mash.stub!(:id).and_return(1)
    @mash.destroy.should be_true
  end
  
  
  
end