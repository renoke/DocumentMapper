module DocumentMapper

module Agregation
  module ClassMethods
    def aggregate(card, name, options={})
      
      relation_name = name.to_s.downcase
      klass  = const_get(relation_name.camelize)
      
      case 
      when card.to_s == '1'
        aggregate_one(relation_name, klass, options)
      else
        aggregate_many(name, options)
      end
    
    end
    
    private
    
    def aggregate_one(relation_name,klass, options={})      
      define_method(relation_name) do
        klass.new(regular_reader(relation_name))
      end
      
      define_method("#{relation_name}=") do |instance|
        self[relation_name] = instance
      end
            
    end
    
  end
  
  module InstanceMethods
    
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end

end