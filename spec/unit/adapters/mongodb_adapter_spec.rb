require File.dirname(__FILE__) + '/../../spec_helper'

describe "MongodbAdapter" do
  
  before(:all) do
    DocumentMapper.setup(:adapter => 'mongodb', :database=>"test", :collection=>'test_collection')
    @adapter = DocumentMapper.repository
  end
  
  after(:all) do
    @adapter.clear
  end
  
  describe "Minimal" do
    it_should_behave_like "a DocumentMapper Adapter"
  end
  
  describe "Read" do
    before(:all) do
      9.times do |i|
        @adapter.create({'_id'=>"id#{i}","foo"=>i, "bar"=> i*10, "test"=>true})
      end
    end
    
    describe "all" do
      
      it "reads all documents document" do
        @adapter.read_all.entries.size.should == 9
      end

      it "return document like a Hash" do
        it = @adapter.read_all.entries 
        it.first.should be_a(Hash)
        it.first['_id'].should  == 'id0'
      end

      it "reads with query on keys" do
        @adapter.read_all(:foo=>1).entries.size.should == 1
      end

      it "reads with advanced query (less than)" do
        @adapter.read_all(:foo=>{'$lt'=>5}).entries.size.should == 5
      end

      it "reads with advanced query (less than or equal)" do
        @adapter.read_all(:foo=>{'$lte'=>5}).entries.size.should == 6
      end    

      it "reads with advanced query (greater than)" do
        @adapter.read_all(:foo=>{'$gt'=> 7}).entries.size.should == 1
      end

      it "reads with advanced query (greater than equal)" do
        @adapter.read_all(:foo=>{'$gte'=> 7}).entries.size.should == 2
      end

      it "reads with advanced query (between)" do
        @adapter.read_all(:foo=>{'$gte'=>5, '$lte'=>8}).entries.size.should == 4
      end

      it "reads with advanced query (in)" do
        @adapter.read_all(:foo=>{'$in' => [1,2]}).entries.size.should == 2
      end

      it "reads with advanced query (regexp)" do
        @adapter.read_all(:foo=> /[1|2]/).entries.size.should == 2
      end
      
    end
    
    describe "options" do
      
      it "reads with limit options " do
        @adapter.read_all(:limit=>2).entries.size.should == 2
      end
      
      it "reads with query and limit options " do
        @adapter.read_all(:foo=>{'$lte'=>5}, :limit=>1).entries.size.should == 1
      end
      
      it "reads with sort options" do
        @adapter.read_all(:sort=>{'foo'=>1}).entries.size.should == 9 
        @adapter.read_all(:sort=>{'foo'=>1}).first['foo'].should == 0   
        @adapter.read_all(:sort=>{'foo'=>-1}).first['foo'].should == 8  
      end
      
      it "reads with offset options" do
        @adapter.read_all(:offset => 4).entries.size.should == 5
      end
      
      it "reads with fields/select options" do
        @adapter.read_all(:fields => 'bar').entries.size.should == 9
        @adapter.read_all(:fields => 'bar').first.keys.should == ['_id','bar']
        @adapter.read_all(:select => 'bar').first.keys.should == ['_id','bar']
      end
      
    end
    
    describe "ids" do
      
      it "reads by one or more id" do
        @adapter.read_ids('id1','id2').size.should == 2
      end
      
    end
    
    describe "first" do
      
      before(:all) do
        @it = @adapter.read_one
      end
      
      it "reads first document found" do
        @it['_id'].should == 'id0'
        @it['test'].should be_true
      end
      
      it "is a Hash" do
        @it.should be_a(Hash)
      end
      
    end
    
    describe "adapter without collection name" do
       before(:all) do
         DocumentMapper.setup(:adapter => 'mongodb', :database=>"test")
         @adapter = DocumentMapper.repository
       end
       
       it "still return a collection if no collection is given" do
         @adapter.collection.should be_a(XGen::Mongo::Driver::Collection)
       end
       
       it "should return empty name if collection option is empty" do
         @adapter.collection.name.should be_nil
       end
       
       it_should_behave_like "a DocumentMapper Adapter"   
    end

    describe "adapter with class options" do
      before(:all) do
        DocumentMapper.setup(:adapter=> 'mongodb', :database=>"test", :class=>'Dummy')
        @adapter = DocumentMapper.repository
      end
      
      it "returns a collection with class name" do
        @adapter.collection.name.should == 'Dummy'
      end
    end
  end
  
  
end