=begin
This class intend to handle the String representation of a Symbolic expression
Two formats will be soon supported: standard and LaTeX
=end
module Symbolic
  class Printer
    class << self
      def brackets(var)
        [Numeric, Variable, Function].any? {|c| var.is_a? c } ? var.to_s : "(#{var})"
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
      def exponent(base, exponent)
        "#{brackets base}#{"**#{brackets exponent}" if exponent != 1}"
      end
      
      # Summands
      def remainder(n)
        "#{'+' if n > 0}#{n}"
      end
    end
  end
end
