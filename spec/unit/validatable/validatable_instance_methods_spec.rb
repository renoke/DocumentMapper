require File.dirname(__FILE__) + '/../../spec_helper'

describe Validatable do
  
  before(:all) do
    
    class Ocean < Flat::Document
      validates_presence_of :water
    end
    
  end
  it "should respond_to valid?" do
    @it = Ocean.new
    @it.should respond_to(:valid?)
  end
end