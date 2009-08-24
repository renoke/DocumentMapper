require File.dirname(__FILE__) + '/../spec_helper'


describe DocumentMapper::Crud do
  
  before(:all) do
    DocumentMapper.setup(:adapter => 'mongodb', :database=>"test")
  end
  
  after(:all) do
    DocumentMapper.repository(:collection=>'Bill').clear
  end
  
  it_should_behave_like "a mapper with minimal crud methods"
  
  it "should have a collection with class name" do
    Bill.db.collection.name.should == 'Bill'
  end
end