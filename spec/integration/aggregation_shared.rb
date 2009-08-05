
describe "Document with aggregation", :shared=>true do 
  
  before(:all) do
    class Bill < DocumentMapper::Base
      aggregate 1, :vat_footer
    end
    
    class VatFooter < DocumentMapper::Base
      
      def total
        amount + tax
      end
    end
  end

  describe "Single Aggregation" do
    
    it "saves document" do
      vat = VatFooter.new(:amount=>100, :tax=>10)
      bill = Bill.new(:vat_footer=>vat)
      bill.save.should be_true
    end
    
    it "get document with aggregation" do
      bill = Bill.first
      bill.vat_footer.should be_a(VatFooter)
    end
    
  end
  
end