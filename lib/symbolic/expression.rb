module Symbolic
  class Expression
    include Symbolic

    class << self
      def add(var1, var2)
        simplify_expression! expression = unite(convert(var1), convert(var2))
        simplify(*expression) || new(*expression)
      end

      def subtract(var1, var2)
        add var1, convert(var2).reverse
      end

      def unite(expr1, expr2)
        numeric = unite_numeric expr1.numeric, expr2.numeric
        symbolic = unite_symbolic expr1.symbolic, expr2.symbolic
        [numeric, symbolic]
      end

      def unite_symbolic(symbolic1, symbolic2)
        symbolic1.merge(symbolic2) {|base, coef1, coef2| coef1 + coef2 }
      end

      def unite_numeric(numeric1, numeric2)
        numeric1.send self::OPERATION, numeric2
      end

      def convert(var)
        case var
        when Summands then summands var
        when Factors  then factors var
        when Numeric  then numeric var
        else one var; end
      end

      def numeric(numeric)
        new numeric, {}
      end

      def one(symbolic)
        new self::IDENTITY, symbolic => 1
      end

      def simple?(var)
        case var
        when Numeric, Variable, Function
          true
        when Summands
          false
        when Factors
          var.symbolic.all? {|k,v| simple? k }
        else
          false
        end
      end
    end

    attr_reader :numeric, :symbolic

    def initialize(numeric, symbolic)
      @numeric, @symbolic = numeric.freeze, symbolic.freeze
    end

    def variables
      @symbolic.map {|k,v| [k.variables, v.variables] }.flatten.uniq
    end

    def numeric_equal(object)
      begin
	object.numeric == @numeric
      rescue
	false
      end
    end
    
    def symbolic_equal(object)
      begin
	#we need to make sure the classes are the same because both Factors and
        #Summands have .numeric and .symbolic, but we can't say they're equal
        eq = (object.class == self.class)
	#make sure that we have the same number of elements, otherwise the
	#next step could give false positives
        eq &= (object.symbolic.size == @symbolic.size)
        #hash's == function only checks that the object_ids are equal, but we
	#could have different instances of the same object (mathematically speaking). We
        #need to check that eqach thing in @symbolic appears in object.symbolic as well.
        eq &= object.symbolic.inject(true) do |memo,(key,value)| #go through each kv pair in object.symbolic
	  memo and @symbolic.inject(false) do |memo2,(key2,value2)|#and make sure it appears in @symbolic
	    memo2 or (key2 == key and value2 == value)
	  end
	end
      rescue
	false
      end      
    end
    
    def ==(object)
      self.numeric_equal(object) and self.symbolic_equal(object)
    end
  end
end