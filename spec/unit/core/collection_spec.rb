require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe DocumentMapper::Collection do
  
  before(:each) do
    @it = DocumentMapper::Collection.new({:name=>'one'},{:name=>'two'}, {:name=>'three'})
  end

  context "read element" do
    
    it "returns a document with [int]" do
      @it[0].should be_kind_of(DocumentMapper::Base)
    end
    
    it "returns a collection with [range]" do
      @it[0..2].should be_kind_of(DocumentMapper::Collection) 
      @it[0..2].size.should == 3    
    end
    
    it "returns a collection with [start, length]" do
      @it[0,2].should be_kind_of(DocumentMapper::Collection)
      @it[0,2].size.should == 2
    end
    
    it "returns a document with at[int]" do
      @it.at(1).should be_kind_of(DocumentMapper::Base)
    end
    
    it "returns a document with first" do
      @it.first.should be_kind_of(DocumentMapper::Base)
      @it.first.name.should == 'one'
    end
    
    it "returns a collection with first(int)" do
      @it.first(3).should be_kind_of(DocumentMapper::Collection)
      @it.first(3).size.should == 3
    end
    
    it "returns a document with last" do
      @it.first.should be_kind_of(DocumentMapper::Base)
      @it.last.name.should == 'three'
    end
    
    it "returns a collection with last(int)" do
      @it.last(3).should be_kind_of(DocumentMapper::Collection)
      @it.last(3).size.should == 3
    end
    
    it "returns a document with pop" do
      @it.pop.should be_kind_of(DocumentMapper::Base)
      @it.size.should == 2
    end
    
    it "returns a document with shift" do
      @it.shift.should be_kind_of(DocumentMapper::Base)
      @it.size.should == 2
    end
    
  end
  
  context "insert element" do
    
    it "push elements" do
      @it.push({:name=>'four'})
      @it.should be_kind_of(DocumentMapper::Collection)
      @it.size.should == 4
    end
    
    it "unshift elements" do
      @it.unshift({:name=>'zero'})
      @it.should be_kind_of(DocumentMapper::Collection)
      @it.size.should == 4
    end
    
  end
  
  context "manipulating collection" do
    
    it "returns uniq elements" do
      @it = DocumentMapper::Collection.new({:name=>'one'},{:name=>'one'})
      @it.uniq.should be_kind_of(DocumentMapper::Collection)
    end
    
  end
  
end