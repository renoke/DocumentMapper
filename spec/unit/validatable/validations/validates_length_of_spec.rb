require File.dirname(__FILE__) + '/../../../spec_helper'

describe Validatable::ValidatesLengthOf do
  
  before(:all) do
    class ::Montagne < FlatDoc::Mash
      validates_length_of :name, :maximum => 10
    end
    
    class ::Valley < FlatDoc::Mash
      validates_length_of :name, :minimum => 2
    end
    
    class ::Alpes < FlatDoc::Mash
      validates_length_of :name, :within => (2...10)
    end
    
    @max = ::Montagne.new
    @min = ::Valley.new
    @range = ::Alpes.new
  end
  
  it "should validate if field size is below maximum" do
    @max.name = 'a' * 10
    @max.should be_valid
  end
  
  it "should not validate if field size is over maximum" do
    @max.name = 'a' * 11
    @max.should_not be_valid
  end
  
  it "should validate if field size is over minimum" do
    @min.name = 'a' * 2
    @min.should be_valid
  end
  
  it "should not validate if field size is below minimum" do
    @min.name = 'a' * 1
    @min.should_not be_valid
  end
  
  it "should validate if field size is within range" do
    @range.name = 'a' * 3
    @range.should be_valid
  end
  
  it "should not validate if field size is not within range" do
    @range.name = 'a' * 1
    @range.should_not be_valid
  end
end