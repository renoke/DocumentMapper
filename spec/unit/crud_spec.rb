require File.dirname(__FILE__) + '/../spec_helper'
include MockDocument


describe Flat::Crud::ClassMethods do

  before(:each) do
    setup_class
  end
  
  it "get a Flat" do
    @dbclass.should_receive(:get).with(1).and_return('foo'=>'bar', 'id'=>1)
    it = @class.get(1)
    it.should == {'foo'=>'bar', 'id'=>1}
    it.should be_kind_of(Flat::Document)
  end
  
  it "return nil if it couldn't get a Flat" do
    @dbclass.should_receive(:get).with(1).and_return(nil)
    @class.get(1).should be_nil
  end
  
  it "return an error if it couldn't get! a Flat" do
    @dbclass.should_receive(:get).with(1).and_return(nil)
    lambda {@class.get!(1)}.should raise_error
  end
  
  it "create a Flat" do
    instance = Flat::Document.new('foo'=>'bar')
    instance.stub!(:db).and_return(@dbclass)
    @dbclass.should_receive(:create).and_return(1)
    @class.should_receive(:new).with('foo'=>'bar').and_return(instance)
    it = @class.create('foo'=>'bar')
    it.should be_kind_of(Flat::Document)
  end
  
  it "find all Flat" do
    @dbclass.should_receive(:read_all).once.and_return([{:key=>'test1'},{:key=>'test2'}])
    it = @class.all
    it.should be_kind_of(Array)
    it.first.should be_kind_of(Hash)
  end
  
  it "first first Flat" do
    @dbclass.should_receive(:read_one).and_return({:foo=>'bar', :id=>1})
    it = @class.first
    it.should be_kind_of(Flat::Document)
    it.foo.should == 'bar'
  end
  
end




describe Flat::Crud::InstanceMethods do
  
  before(:each) do
    setup_instance
  end
  
  it "instantiate a new Flat" do
    @it = Flat::Document.new(:foo => 'bar').should == {'foo' => 'bar'}
  end
  
  it "saves and creates a Flat" do
    @db.should_receive(:create).and_return(1)
    @it = Flat::Document.new(:foo => 'bar')
    @it.stub!(:db).and_return(@db)
    @it.save
    @it.should be_kind_of(Flat::Document)
    @it.should_not be_new_record
  end
  
  it "saves and updates Flat" do
    @mash.merge!(:foo=>'bar', :id=>1)
    @db.should_receive(:update).and_return({'foo'=>'bar', 'id'=>1})
    @mash.stub!(:id).and_return(1)
    @mash.stub!(:new_record?).and_return(false)
    @mash.save.should == {'foo'=>'bar', 'id'=>1}
  end
  
  it "destroy a Flat" do
    @mash.merge!(:foo=>'bar', :id=>1)
    @db.should_receive(:delete).and_return({'foo' => 'bar', 'id'=>1})
    @mash.stub!(:id).and_return(1)
    @mash.destroy.should be_true
  end
  
  
  
end