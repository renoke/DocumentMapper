describe "a DocumentMapper Adapter", :shared=> true do
  
  it "get a document with his his and return a Hash" do
    document_id = @adapter.create('key'=>'value')
    @adapter.get(document_id).should be_kind_of(Hash)
  end
  
  it "get nil if no document found" do
    @adapter.get('1').should be_nil
  end
  
  it "creates a document and return his id in a String" do
    document_id = @adapter.create('key'=>'value')
    document_id.should be_kind_of(String)
    @adapter.get(document_id).should_not be_nil
  end
  
  it "updates a document and return the document updated" do
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