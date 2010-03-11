module Symbolic::Math
=begin
  This module is a reflection for Math module which allows to use symbolic expressions as parameters for its methods.
=end
  Math.methods(false).each do |method|
    instance_eval <<-CODE, __FILE__, __LINE__ + 1
      def #{method}(argument)
        unless argument.is_a? Numeric
          Symbolic::Function.new(argument,#{method}){|x| ::Math.#{method}(x)}
        else
          ::Math.#{method}(argument)
        end
      end
    CODE
  end
  def hstep
    
  end
end