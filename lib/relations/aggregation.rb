module DocumentMapper

  module Relations

    module Aggregation
      module ClassMethods
        def aggregate(card, name, options={})
          relation = DocumentMapper::Relation.new(:aggregation, name, card, options)         
          relation.many? ? aggregate_many(relation) : aggregate_one(relation)
        end
    
        private
    
        def aggregate_one(relation)      
          define_method(relation.name) do
            relation.klass.new(regular_reader(relation.name))
          end
      
          define_method("#{relation.name}=") do |instance|
            self[relation.name] = instance
          end         
        end
        
        def aggregate_many(relation)
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
  
end
