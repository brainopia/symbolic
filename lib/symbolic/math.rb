module Symbolic::Math
  Math.methods(false).each do |method|
    instance_eval <<-CODE, __FILE__, __LINE__
      def #{method}(argument)
        Symbolic::Function.new argument, :#{method}
      end
    CODE
  end
end