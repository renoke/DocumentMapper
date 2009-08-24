require File.dirname(__FILE__) + '/../../spec_helper'

describe "CouchrestAdapter" do
  
  before(:all) do
    DocumentMapper.setup(:adapter => 'couchrest', :database=>"http://127.0.0.1:5984/flatdoc-test")
    @adapter = DocumentMapper.repository
  end
  
  after(:all) do
    @adapter.clear
  end
  
  context "Minimal" do
    
    it_should_behave_like "a DocumentMapper Adapter"
    
  end
  
  
  
  context "Read" do
    
    before(:all) do
      9.times do |i|
        @adapter.create({'_id'=>"id#{i}","var"=>i, "test"=>true})
      end
      
      @view = {'test' => {'map' => 'function(doc) {
        if (doc.test) {
          emit(doc._id,doc);
        }
      }'}}
      @adapter.create({
        "_id" => "_design/test",
        :views => @view
      })
      
      @slow_view = 'function(doc) {
        if (doc.test) {
          emit(doc._id,doc);
        }
      }'
    end
    
    context "view" do
    
      it "check if a specified view exist" do
        @adapter.has_view?('test/test').should be_true
      end
    
      it "reads nil if no view found" do
        @adapter.has_view?('i-am-not-here').should be_nil
      end
    
      it "reads view" do
        @adapter.read_all('test/test').size.should == 9
        @adapter.read_all('test/test', :startkey=>'id0', :endkey=>'id3').size.should == 4
        @adapter.read_all('test/test', :keys=>['id0', 'id1']).size.should == 2
      end
      
      it "reads view within a limit in options" do
        @adapter.read_all('test/test', :options=>{:limit=>1}).size.should == 1
      end
    
    end
    
    context "ids" do
      
       it "reads from an array of ids" do
          @adapter.read_all('id1').size.should == 1
          @adapter.read_all('id1','id2' ).size.should == 2
          @adapter.read_all(['id1', 'id2']).size.should == 2
        end

        it "reads nil if no id found" do
          @adapter.read_all('i-am-not-here').should be_nil
        end
        
    end
    
    context "all" do
      it "reads all" do
        @adapter.read_all.size.should == 9
      end
      
      it "reads all with :all" do
        @adapter.read_all(:all).size.should == 9
      end
      
      it "reads all with descending order" do
        @adapter.read_all.first['_id'].should == 'id0'
        @adapter.read_all(:descending=>true).first['_id'].should == 'id8'
      end

      it "reads all with a query" do
        @adapter.read_all(:keys=>['id0','id1']).size.should == 2
        @adapter.read_all(:startkey=>'id0', :endkey=>'id3').size.should == 4
      end

      it "reads empty array if nothing found" do
        @adapter.read_all(:key=>'i-am-not-here').should be_nil
      end

      it "reads all within range" do
        @adapter.read_all(:startkey=>'id0', :endkey=>'id3').size.should == 4
      end
      
      it "reads all within limit" do
        @adapter.read_all(:limit=>1).size.should == 1
      end
      
      it "reads all within limit in options" do
        @adapter.read_all(:options=>{:limit=>1}).size.should == 1
      end    
      
      it "reads all with a slow view" do
        @adapter.read_all( :map=>@slow_view).size.should == 9
        @adapter.read_all( :map=>@slow_view, :startkey=>'id0', :endkey=>'id3').size.should == 4
      end
    
      it "reads nil if no document found with a slow view" do
        @adapter.read_all(:map=>@slow_view, :key=>'i-am-not-here').should be_nil
      end
      
      it "reads all with a slow view and a limit in options" do
        @adapter.read_all(:map=>@slow_view, :options=>{:limit=>1}).size.should == 1
      end
      
      it "reads all with a slow and a limit" do
        @adapter.read_all(:map=>@slow_view, :limit=>1).size.should == 1
      end
    end
    
    context "one" do
      it "reads first document and return a Hash" do
        it = @adapter.read_first
        it.should be_kind_of(Hash)
        it['test'].should == true
      end
      
      it "reads first document from view" do
        it = @adapter.read_first('test/test')
        it.should be_kind_of(Hash)
        it['test'].should == true
      end
    end
    

  end
end
