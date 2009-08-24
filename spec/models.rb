class Bill < DocumentMapper::Base
  aggregate 1, :vat_footer
  aggregate :n, :products
end

class VatFooter < DocumentMapper::Base
  def total
    amount + tax
  end
end

class Product < DocumentMapper::Base 
  aggregate 1, :model
end

class Model < DocumentMapper::Base
end