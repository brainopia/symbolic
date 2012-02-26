=begin
This class intend to handle the String representation of a Symbolic expression
Two formats will be soon supported: standard and LaTeX
=end
module Symbolic
  class Printer
    class << self
      def print(o)
        send(o.class.simple_name.downcase, o)
      end

      def brackets(var)
        [Numeric, Variable, Function].any? { |c| var.is_a? c } ? var.to_s : "(#{var})"
      end

      def rational(r)
        "#{r.round == r ? r.to_i : r.to_f}"
      end

      def coef(c)
        "#{'-' if c < 0}#{"#{rational c.abs}*" if c.abs != 1}"
      end
      def coef_with_sign(c)
        "#{ c < 0 ? '-' : '+'}#{"#{rational c.abs}*" if c.abs != 1}"
      end

      # Factors
      def factors(f)
        rfactors, factors = f.symbolic.partition { |b,e| e.is_a?(Numeric) && e < 0 }
        rfactors = rfactors.empty? ? nil : [ 1, Hash[*rfactors.flatten] ]
        factors = factors.empty? ? nil : [ f.numeric, Hash[*factors.flatten] ]

        s = (factors ? output(factors) : rational(f.numeric))
        s << "/#{reversed_output rfactors}" if rfactors
        s
      end
      def output(f) # This has to change ! can be inline in ::factors, but needed also in reversed_output
        coef(f[0]) << f[1].map {|b,e| exponent b,e }.join('*')
      end
      def reversed_output(f) # This has to change ! Please make this non dependent of output ;)
        result = output [f[0], Hash[*f[1].map {|b,e| [b,-e] }.flatten]]
        (f[1].length > 1) ? "(#{result})" : result
      end
      def exponent(base, exponent)
        "#{brackets base}#{"**#{brackets exponent}" if exponent != 1}"
      end

      # Summands
      def summands(s)
        out = s.symbolic.map { |base, coef| coef_with_sign(coef) + brackets(base) }
        out << remainder(s.numeric)
        out[0].sub!(/^\+/, '')
        out.join
      end

      def remainder(n)
        "#{'+' if n > 0}#{n unless n.zero?}"
      end

      # Variable
      def variable(v)
        "#{v.name || :unnamed_variable}"
      end

      # Function
      def functionwrapper(f)
        "#{f.name}(#{f.argument})"
      end

      def constant(c)
        "#{c.name || :unnamed_variable}"
      end
      # Sums
      def sum(s)
        "Sum(#{s.term}, #{s.index} = #{s.lb}..#{s.ub})"
      end
    end
  end
end
