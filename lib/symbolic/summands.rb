# TODO: 2*symbolic is a 2 power of symbolic Summand
require "#{File.dirname(__FILE__)}/expression.rb"
module Symbolic
  require "#{File.dirname(__FILE__)}/expression.rb"
  class Summands < Expression
    OPERATION = :+
    IDENTITY = 0
    class << self
      def summands(summands)
        summands
      end

      def factors(factors)
        if factors.symbolic.length == 1 && factors.symbolic.first[1] == Factors::IDENTITY
          new IDENTITY, factors.symbolic.first[0] => factors.numeric
        else
          new IDENTITY, Factors.new(1, factors.symbolic) => factors.numeric
        end
      end

      def simplify_expression!(summands)
        summands[1].delete_if {|base, coef| coef == 0 }
      end

      def simplify(numeric, symbolic)
        if symbolic.empty? #only the numeric portion
          numeric
        elsif numeric == IDENTITY && symbolic.size == 1 #no numeric to add and only one symbolic, so can just return the one base*coefficient
          symbolic.first[1] * symbolic.first[0]
        elsif symbolic.size > 1 #let's look to see if any base gets repeated, so that they can be combined
          temp = []
          symbolic.each_key do |base1|
            temp = symbolic.find_all{|base2,v2| base1 == base2} #temp is an array of form [[b,c1],[b,c2]...]
            break if temp.size > 1 #found a duplicate base
          end
          if temp.size > 1
            repeated_base = temp[0][0]
            new_coef = temp.inject(0){|sum, (b,coeff)| sum + coeff} #sum up the old coefficients
            #it could be that there is more than one repeated base, but the next line effectively is recursion, and it'll take care of that
            Summands.new(numeric, symbolic.reject{|k,v| k == repeated_base}) + new_coef * repeated_base
          else
            nil
          end
        end
      end
    end

    def value
      if variables.all?(&:value)
        symbolic.inject(numeric) {|value, (base, coef)| value + base.value * coef.value }
      end
    end

    def reverse
      self.class.new( -numeric, Hash[*symbolic.map {|k,v| [k,-v]}.flatten] )
    end
    def value
      @symbolic.inject(@numeric){|m,(base,coefficient)| m + coefficient * base.value}
    end
    def subs(to_replace, replacement=nil)
      if replacement == nil and to_replace.is_a?(Hash)
	super(to_replace)
      else
	@symbolic.inject(@numeric){|m,(base,coefficient)| m + coefficient * base.subs(to_replace, replacement)}
      end
    end

    def diff(wrt)
      @symbolic.inject(0){|m,(base,coefficient)| m + coefficient * base.diff(wrt)}
    end
  end
end