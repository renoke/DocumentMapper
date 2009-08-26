require File.dirname(__FILE__) + '/../spec_helper'


describe DocumentMapper::Relations::Aggregation do
  
  before(:all) do
    DocumentMapper.setup(:adapter => 'mongodb', :database=>"test")
  end
  
  after(:each) do
    DocumentMapper.repository(:collection=>'Bill').clear
  end
  
  it_should_behave_like "Document with aggregation"
end