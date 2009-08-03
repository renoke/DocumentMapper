require File.dirname(__FILE__) + '/../../../spec_helper'

describe Validatable::ValidatesFormatOf do
  before(:all) do
    class ::Script < DocumentMapper::Base
      validates_format_of :language, :with => /P(erl|ython)/ 
    end
    @it = ::Script.new
  end
  
  it "should validate if field match the regular expression with" do
    @it.language = 'Perl'
    @it.should be_valid
  end
  
  it "should not validate if field doesn't match the regulare expression" do
    @it.language = 'Java'
    @it.shoud_not be_valid
  end
  
  it "should return error message if invalid" do
    @it.language = 'C++'
    @it.valid?.should be_false
    @it.errors.on(:language).should =='is invalid'
  end
  
end