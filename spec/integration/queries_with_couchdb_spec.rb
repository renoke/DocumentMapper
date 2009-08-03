require File.dirname(__FILE__) + '/../spec_helper'


describe DocumentMapper::Crud do
  
  before(:all) do
    DocumentMapper.setup(:adapter => 'couchdb', :database=>"http://127.0.0.1:5984/flatdoc-test")
    
    class Bill < DocumentMapper::Base
    end
  end
  
  after(:all) do
    DocumentMapper.repository.clear
  end
  
  it_should_behave_like "a Document Class for CRUD"
  it_should_behave_like "a Document Instance for CRUD"
end