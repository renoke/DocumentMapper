require File.dirname(__FILE__) + '/../spec_helper'


describe DocumentMapper::Relations::Aggregation do
  
  before(:all) do
    DocumentMapper.setup(:adapter => 'couchrest', :database=>"http://127.0.0.1:5984/flatdoc-test")
  end
  
  after(:all) do
    DocumentMapper.repository.clear
  end
  
  context "single association" do
    
  end
  
end