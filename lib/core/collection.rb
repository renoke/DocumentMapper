module DocumentMapper
  class Collection < Array
    
    def initialize(*args)
      args = args.pop if args.size == 1
      super(args)
    end
    
    def [](*args)
      args = args.pop if args.size == 1
      case args
      when Integer
        DocumentMapper::Base.new(self.at(args))
      when Range
        DocumentMapper::Collection.new(super(args))
      when Array
        DocumentMapper::Collection.new(super(args.first, args.last))
      end
    end
    
    def at(int)
        DocumentMapper::Base.new(super(int))
    end
    
    def first(int=nil)
      case int
      when nil
        self.at(0)
      when Integer
        self[0,int]
      end
    end
    
    def last(int=nil)
      case int
      when nil
        self.reverse.at(0)
      when Integer
        self.reverse[0,int]
      end
    end
    
    def pop
      DocumentMapper::Base.new(super)
    end
    
    def shift
      DocumentMapper::Base.new(super)
    end
    
  end
end