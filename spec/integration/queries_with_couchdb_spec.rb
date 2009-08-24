require File.dirname(__FILE__) + '/../spec_helper'


describe DocumentMapper::Crud do
  
  before(:all) do
    DocumentMapper.setup(:adapter => 'couchrest', :database=>"http://127.0.0.1:5984/flatdoc-test")
  end
  
  after(:all) do
    DocumentMapper.repository.clear
  end
  
  it_should_behave_like "a mapper with minimal crud methods"
  
  context "In specific couchdb queries" do
    
    before(:all) do
      9.times do |i|
        Bill.create(:number=>i, :domain=> 'consulting')
      end

      @slow = 'function(doc) {
        if (doc.domain) {
          emit(doc.number,doc);
        }
      }'
      
      @view = {'number' =>{'map' => @slow}}
      
      Bill.create({
        "_id" => "_design/test",
        :views => @view
      })
    end
    
    it "should read slow view" do
      Bill.all(:map => @slow).size.should == 9
    end
    
    it "should read view" do
      Bill.all('test/number').size.should == 9
    end
    
    it "reads with descending options" do
      pending("wait for sorting")
      #Bill.all(:descending=>true).first['value']['number'].should == 8
    end
    
  end
  
end