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
        numeric1.send operation, numeric2
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
        new identity_element, symbolic => 1
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
      @symbolic.map {|k,v| [variables_of(k), variables_of(v)] }.flatten.uniq
    end

    def ==(object)
      (object.numeric == @numeric) and (object.symbolic == @symbolic) rescue false
    end
  end
end