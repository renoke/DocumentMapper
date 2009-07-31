require File.dirname(__FILE__) + '/../../../spec_helper'

describe Validatable::ValidatesTrueFor do
  
  before(:all) do
    class River < Flat::Document
      validates_true_for :origin, :logic => lambda { origin == 'lac' }
    end
  end

  
  it "should validate if field is true" do
    @it = River.new
    @it.origin = 'lac'
    @it.should be_valid
  end
  
  it "should not validate if field is not true" do
    @it = River.new
    @it.origin = 'boo'
    @it.should_not be_valid
  end
end