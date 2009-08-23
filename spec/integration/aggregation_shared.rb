class Bill < DocumentMapper::Base
  aggregate 1, :vat_footer
  aggregate :n, :products
end

class VatFooter < DocumentMapper::Base
  def total
    amount + tax
  end
end

class Product < DocumentMapper::Base; end

describe "Document with aggregation", :shared=>true do 

  context "Single Aggregation" do 
    it "saves and retrieve document with aggregation" do
      vat = VatFooter.new(:amount=>100, :tax=>10)
      bill = Bill.new(:vat_footer=>vat)
      bill.save.should be_true
      bill = Bill.first
      bill.vat_footer.should be_a(VatFooter)
      bill.vat_footer.total.should == 110
    end
  end
  
  context "Many Aggregation" do
    it "saves and retrieve document with aggregation" do
      products = [Product.new(:name=>'couchdb', :quantity=>10), Product.new(:name=>'mongodb', :quantity=>20)]
      bill = Bill.new(:products=>products, :number=>1234)
      bill.save.should be_true
      bill = Bill.first
      bill.products.should be_a(Array)
      Product.new(bill.products.first).should be_kind_of(Product)
      bill.products.first.should be_kind_of(Product)
    end
    
    it "aggregation can be used  like an array" do
      bill = Bill.new
      bill.products << Product.new(:name=>'tokyo')
      bill.products << Product.new(:name=>'berkley')
      bill.products.size.should == 2
      bill.save.should be_true
      bill = Bill.first
      bill.products.size.should == 2
      bill.destroy
    end
  end
end