require File.dirname(__FILE__) + '/../../spec_helper'


describe DocumentMapper::Agregation::ClassMethods do
  
  before(:all) do
    class Adress < DocumentMapper::Base
      
    end
    
    class Person < DocumentMapper::Base
      agregate 1, :adress
    end
    
    @it = Person.new
  end
  
  it "defines an agregate method" do
    @it.should respond_to(:adress)
  end
  
  it "returns an instance of agregate class" do
    @it.adress.should be_kind_of(Adress)
  end
  
  it "instantiate an agregate class with stored hash" do
    @it['adress'] = {:street=>'Vaya con Dios', :city=>'Angel'}
    @it.adress.street.should == 'Vaya con Dios'
  end
  
end