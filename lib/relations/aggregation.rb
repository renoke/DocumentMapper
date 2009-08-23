

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
            relation.klass.new(self[relation.name])
          end
      
          define_method("#{relation.name}=") do |instance|
            self[relation.name] = instance
            instance
          end         
        end
        
        def aggregate_many(relation)
          define_method(relation.name) do
            self[relation.name] = [] if self[relation.name].nil?
            self[relation.name].collect! {|doc| relation.klass.new(doc)}
          end
      
          define_method("#{relation.name}=") do |array|
            self[relation.name] = array
            array
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
