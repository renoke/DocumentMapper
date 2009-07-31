require File.dirname(__FILE__) + '/../spec_helper'


describe Flat::Crud do
  
  before(:all) do
    Flat.setup(:adapter => 'couchdb', :database=>"http://127.0.0.1:5984/flatdoc-test")
    
    class Bill < Flat::Document
    end
  end
  
  after(:all) do
    Flat.repository.clear
  end
  
  it_should_behave_like "a FlatDoc Class for CRUD"
  it_should_behave_like "a FlatDoc Instance for CRUD"
end