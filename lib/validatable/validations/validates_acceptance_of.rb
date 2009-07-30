module Validatable
  class ValidatesAcceptanceOf < ValidationBase #:nodoc:
    option :accept
    default :accept => [true, "true", "t", "1", 1]
    
    def valid?(instance)
      #instance.send(self.attribute) == "true"
      accept.include?(instance.send(self.attribute) )
    end
    
    def message(instance)
      super || "must be accepted"
    end
  end
end