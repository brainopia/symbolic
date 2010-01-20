=begin
This class intend to handle the String representation of a Symbolic expression
Two formats will be soon supported: standard and LaTeX
=end
module Symbolic
  class Printer
    class << self
      def rational(r)
        (r.round == r ? r.to_i : r.to_f).to_s
      end
    end
  end
end
