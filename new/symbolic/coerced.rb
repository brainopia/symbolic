module Symbolic
=begin
 This class restores a correct order of arguments after using a coerce method.
 For example, expression "1 - symbolic" calls to Symbolic#coerce
 which gives us a power to reverse a receiver and parameter of method
 so we set a receiver as Coerced.new(symbolic) to reverse arguments back after coercing.
=end
#  class Coerced < Abelian
#    def initialize(value)
#      @member = value
#    end
#
#    def +(numeric)
#      Summands.new numeric, @symbolic
#    end
#
#    def -(numeric)
#      Summands.new numeric, -@symbolic
#    end
#
#    def *(numeric)
#      Factors.new numeric, @symbolic
#    end
#
#    def /(numeric)
#      Factors.new numeric, @symbolic**-1
#    end
#
#    def **(numeric)
#      Factors.new(1, numeric) ** @symbolic
#    end
#  end
end