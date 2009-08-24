module DocumentMapper
  
  class Relation
      
      attr_reader :type, :name, :options, :min, :max
      
      def initialize(type, name, cardinality, options=())
        @type         = type
        @name         = name
        @options      = options
        extract_min_max(cardinality)
      end
      
      def class_name
        @class_name ||= options[:class_name] || (many? ? name.to_s.classify : name.to_s.camelize)
      end
      
      def klass
        @klass ||= DocumentMapper.const_get(class_name)
      end
      
      
      def many?
        max > 1
      end
      
      def n
        1.0/0
      end
      
      
      private
      
      def extract_min_max(cardinality)       
        case cardinality
        when Integer
          @min = @max = cardinality
        when Range
          @min, @max  = cardinality.min, cardinality.max
        when :n
          @min, @max  = 0, n
        end
      end
      
  end
end