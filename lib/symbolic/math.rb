module Symbolic::Math
  Math.methods(false).each do |method|
    instance_eval <<-CODE, __FILE__, __LINE__
      def #{method}(argument)
        unless argument.is_a? Numeric
          Symbolic::Function.new argument, :#{method}
        else
          ::Math.#{method} argument
        end
      end
    CODE
  end
end