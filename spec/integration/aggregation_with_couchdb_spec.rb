require File.dirname(__FILE__) + '/../spec_helper'


describe DocumentMapper::Relations::Aggregation do
  
  before(:all) do
    DocumentMapper.setup(:adapter => 'couchrest', :database=>"http://127.0.0.1:5984/flatdoc-test")
  end
  
  after(:all) do
    DocumentMapper.repository.clear
  end
  
  it_should_behave_like "Document with aggregation"
  
  context "read aggregation" do
    
    before(:all) do
      @slow_view = 'function(doc) {
        if (doc.products) {
            for(var idx in doc.products) {
              emit(doc.products[idx].name,doc);
            }
        }
      }'
      
      @view = {'name' => {'map' => "#{@slow_view}" }}
      
      9.times do |i|
        products = [Product.new(:name => 'a'*i)]
        Bill.create(:number=> i, :products=>products)
      end
      
      Bill.create({
        "_id" => "_design/products",
        :views => @view
      })
    end
    
    it "reads with slow view" do
      Bill.all(:map => @slow_view).size.should == 9
      Bill.all(:map => @slow_view, :key=>'aaa').size.should == 1
    end
    
    it "reads with view" do
      Bill.all('products/name').size.should == 9
      Bill.all('products/name', :key=>'aaa').size.should == 1
    end
    

    
  end
end