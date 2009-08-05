module DocumentMapper

  module Relations

    module Aggregation
      module ClassMethods
        def aggregate(card, name, options={})
          relation = DocumentMapper::Relation.new(:aggregation, name, card, options)
          case 
          when card.to_s == '1'
            aggregate_one(relation)
          else
            aggregate_many(relation)
          end
    
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
