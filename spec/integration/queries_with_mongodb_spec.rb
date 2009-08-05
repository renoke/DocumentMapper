require File.dirname(__FILE__) + '/../spec_helper'


describe DocumentMapper::Crud do
  
  before(:all) do
    DocumentMapper.setup(:adapter => 'mongodb', :database=>"test")
    
    class Bill < DocumentMapper::Base
    end
  end
  
  after(:all) do
    DocumentMapper.repository(:collection=>'Bill').clear
  end
  
  it_should_behave_like "a Document Class for CRUD"
  it_should_behave_like "a Document Instance for CRUD"
  
  it "should have a collection with class name" do
    Bill.db.collection.name.should == 'Bill'
  end
end