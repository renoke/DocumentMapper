require File.dirname(__FILE__) + '/../../spec_helper'

describe "MongodbAdapter" do
  
  before(:all) do
    DocumentMapper.setup(:adapter => 'mongodb', :database=>"test")
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
        @adapter.create({"foo"=>i, "bar"=> i*10, "test"=>true})
      end
    end
    
    context "all" do
      
      it "reads all documents document" do
        @adapter.read_all.entries.size.should == 9
      end

      it "return document like a Hash" do
        it = @adapter.read_all.entries 
        it.first.should be_a(Hash)
        it.first['foo'].should  == 0
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
    
    context "options" do
      
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
    
    context "ids" do
      it "reads by one or more id" do
        doc1 = @adapter.create(:foo=>'bar')
        doc2 = @adapter.create(:bar=>'foo')
        @adapter.read_ids(doc1,doc2).size.should == 2
      end
      
    end
    
    context "first" do
      
      it "reads first document found" do
        @it = @adapter.read_first
        @it['foo'].should == 0
      end
      
      it "is a Hash" do
        @it = @adapter.read_first
        @it.should be_a(Hash)
      end
      
      it "reads first document with criteria" do
        @it = @adapter.read_first('foo', :foo=>{"$gte"=>5})['foo'].should == 5
      end
      
    end
    
    context "last" do
      
      it "reads last document found" do
        @it = @adapter.read_last('foo')
        @it['foo'].should == 8
      end
      
      it "reads last document with condition" do
        @it = @adapter.read_last('foo',:foo=>{"$lte"=>4})['foo'].should == 4
      end
    end
    
    context "adapter without collection name" do
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

    context "adapter with class options" do
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