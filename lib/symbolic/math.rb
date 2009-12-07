module Symbolic::Math
  [:cos, :sin].each do |function|
    method = <<-CODE
      def #{function}(argument)
        Symbolic::Function.new argument, :#{function}
      end
    CODE
    instance_eval method, __FILE__, __LINE__
  end
end