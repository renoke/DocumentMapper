require File.dirname(__FILE__) + '/../spec_helper'


describe KeyValueMapper::Crud do
  
  before(:all) do
    KeyValueMapper.setup(:adapter => 'mongodb', :database=>"test", :collection=>'test')
    
    class Bill < KeyValueMapper::Document
    end
  end
  
  after(:all) do
    KeyValueMapper.repository.clear
  end
  
  it_should_behave_like "a Document Class for CRUD"
  it_should_behave_like "a Document Instance for CRUD"
end