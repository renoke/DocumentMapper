describe "a DocumentMapper Adapter", :shared=> true do
  
  it "get document id like a Hash" do
    document_id = @adapter.create('key'=>'value')
    @adapter.get(document_id).should be_kind_of(Hash)
  end
  
  it "returns empty hash of no document correspond to id" do
    @adapter.get('1').should be_nil
  end
  
  it "creates a document and return an id" do
    @adapter.create('key'=>'value').should_not be_nil
  end
  
  it "updates document and return the document updated" do
    document_id = @adapter.create('key'=>'value')
    @adapter.update(document_id,{'key'=>'foobar'})['key'].should == 'foobar' 
  end
  
  it "returns nil if it try to update document that don't exist" do
    @adapter.update('nothing',{'key' => 'foobar'}).should be_nil
  end
  
  it "deletes document and return the document deleted" do
    document_id = @adapter.create('key'=>'value')
    @adapter.delete(document_id)['key'].should == 'value'
    @adapter.get(document_id).should be_nil
  end
  
  it "returns nil if it try to delete document that doesn't exist" do
    @adapter.delete('nothing').should be_nil
  end
 
end