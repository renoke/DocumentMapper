require File.dirname(__FILE__) + '/../../spec_helper'
describe DocumentMapper::CoreMash do
  before(:each) do
    @mash = DocumentMapper::Base.new
  end
  2
  it "should return attributes" do
    @mash.foo = 'bar'
    @mash.bar = 'foo'
    @mash.should == {'foo' => 'bar', 'bar'=>'foo'}
  end
  
  it "should return attribute with send" do
    @mash.foo = 'bar'
    @mash.send('foo').should == 'bar'
    @mash.send('dummy').should be_nil
  end
  
  it "should inherit from hash" do
    @mash.is_a?(Hash).should be_true
  end
  
  it "should be able to set hash values through method= calls" do
    @mash.test = "abc"
    @mash["test"].should == "abc"
  end
  
  it "should be able to retrieve set values through method calls" do
    @mash["test"] = "abc"
    @mash.test.should == "abc"
  end
  
  it "should test for already set values when passed a ? method" do
    @mash.test?.should be_false
    @mash.test = "abc"
    @mash.test?.should be_true
  end
  
  it "should make all [] and []= into strings for consistency" do
    @mash["abc"] = 123
    @mash.key?('abc').should be_true
    @mash["abc"].should == 123
  end
  
  it "should have a to_s that is identical to its inspect" do
    @mash.abc = 123
    @mash.to_s.should == @mash.inspect
  end
  
  it "should return nil instead of raising an error for attribute-esque method calls" do
    @mash.abc.should be_nil
  end
  
  it "should return a Mash when passed a bang method to a non-existenct key" do
    @mash.abc!.is_a?(DocumentMapper::Base).should be_true
  end
  
  it "should return the existing value when passed a bang method for an existing key" do
    @mash.name = "Bob"
    @mash.name!.should == "Bob"
  end
  
  it "#initializing_reader should return a Mash when passed a non-existent key" do
    @mash.initializing_reader(:abc).is_a?(DocumentMapper::Base).should be_true
  end
  
  it "should allow for multi-level assignment through bang methods" do
    @mash.author!.name = "Michael Bleigh"
    @mash.author.should == DocumentMapper::Base.new(:name => "Michael Bleigh")
    @mash.author!.website!.url = "http://www.mbleigh.com/"
    @mash.author.website.should == DocumentMapper::Base.new(:url => "http://www.mbleigh.com/")
  end
  
  it "#deep_update should recursively mash mashes and hashes together" do
    @mash.first_name = "Michael"
    @mash.last_name = "Bleigh"
    @mash.details = {:email => "michael@asf.com"}.to_mash
    @mash.deep_update({:details => {:email => "michael@intridea.com"}})
    @mash.details.email.should == "michael@intridea.com"
  end
  
  it "should convert hash assignments into mashes" do
    @mash.details = {:email => 'randy@asf.com', :address => {:state => 'TX'} }
    @mash.details.email.should == 'randy@asf.com'
    @mash.details.address.state.should == 'TX'
  end
  
  it "should store an array and use array's methods" do
    @mash.array = []
    @mash.array << 1
    @mash.array.push 2
    @mash.array.should == [1,2]
  end
  
  context "#initialize" do
    it "should convert an existing hash to a Mash" do
      converted = DocumentMapper::Base.new({:abc => 123, :name => "Bob"})
      converted.abc.should == 123
      converted.name.should == "Bob"
    end
  
    it "should convert hashes recursively into mashes" do
      converted = DocumentMapper::Base.new({:a => {:b => 1, :c => {:d => 23}}})
      converted.a.is_a?(DocumentMapper::Base).should be_true
      converted.a.b.should == 1
      converted.a.c.d.should == 23
    end
  
    it "should convert hashes in arrays into mashes" do
      converted = DocumentMapper::Base.new({:a => [{:b => 12}, 23]})
      converted.a.first.b.should == 12
      converted.a.last.should == 23
    end
    
    it "should convert an existing Mash into a Mash" do
      initial = DocumentMapper::Base.new(:name => 'randy', :address => {:state => 'TX'})
      copy = DocumentMapper::Base.new(initial)
      initial.name.should == copy.name      
      initial.object_id.should_not == copy.object_id
      copy.address.state.should == 'TX'
      copy.address.state = 'MI'
      initial.address.state.should == 'TX'
      copy.address.object_id.should_not == initial.address.object_id
    end
    
    it "should accept a default block" do
      initial = DocumentMapper::Base.new { |h,i| h[i] = []}
      initial.default_proc.should_not be_nil
      initial.default.should be_nil
      initial.test.should == []
      initial.test?.should be_true
    end
  end
  
  context "aggregation" do
    it "should aggregate mash object" do
      inside = DocumentMapper::Base.new(:foo=>'bar', :bar=>'foo')
      @mash.inside = inside
      @mash.inside.foo.should == 'bar'
    end
    
    it "should aggregate hash object" do
      inside = {:foo=>'bar', :bar=>'foo'}
      @mash.inside = inside
      @mash.inside.should be_kind_of(DocumentMapper::Base)
      @mash.inside.foo.should == 'bar'
    end
  end
end
 
describe Hash do
  it "should be convertible to a Mash" do
    mash = {:some => "hash"}.to_mash
    mash.is_a?(DocumentMapper::Base).should be_true
    mash.some.should == "hash"
  end
  
  it "#stringify_keys! should turn all keys into strings" do
    hash = {:a => "hey", 123 => "bob"}
    hash.stringify_keys!
    hash.should == {"a" => "hey", "123" => "bob"}
  end
  
  it "#stringify_keys should return a hash with stringified keys" do
    hash = {:a => "hey", 123 => "bob"}
    stringified_hash = hash.stringify_keys
    hash.should == {:a => "hey", 123 => "bob"}
    stringified_hash.should == {"a" => "hey", "123" => "bob"}
  end
  
end