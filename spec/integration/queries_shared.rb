describe "a mapper with minimal crud methods", :shared => true do
  
  before(:all) do
    10.times do |i|
      Bill.create(:type=>'Bill', :number=>"#{i}")
    end
  end
  
  it "reads 10 documents after creating 10 bills" do
    it = Bill.all
    it.should be_a(Array)
    it.size.should == 10
  end
  
  it "reads first document as a document" do
    it = Bill.first
    it.number.to_i.should >= 0
    it['type'].should == 'Bill'
    it.should be_a(DocumentMapper::Base)
  end
  
  
  it "gets a document with id" do
    id = Bill.first.id
    it = Bill.get(id)
    it.id.should === id
  end
  
  it "raises an error if it didn't get! a document" do
    lambda{Bill.get! 'I-am-not-here'}.should raise_error
  end
  
  it "returns an id of a document" do
    it = Bill.first
    it.id.should_not be_nil
    it.id.should == it['_id']
  end
  
  it "instantiates a new document" do
    it = Bill.new(:type => 'Bill', :amount=>'100.0', :date=>'12.07.2009')
    it.amount.should == '100.0'
    it.date.should == '12.07.2009'
    it.id.should be_nil
    it.should be_new_record
  end
  
  it "saves a new document" do
    it = Bill.new(:type => 'Bill', :amount=>'300', :date=>'12.07.2009')
    it.save.should be_kind_of(Bill)
    it.should_not be_new_document
    it.id.should_not be_nil
  end
  

end