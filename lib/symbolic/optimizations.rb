module Symbolic
  module Optimizations
    Symbolic.operations.each do |operation_sign, operation_name|
      method = <<-CODE
        def #{operation_name}(var1, var2)
          #{operation_name.to_s.capitalize}.optimize(var1, var2) || Expression.new(var1, var2, '#{operation_sign}')
        end
      CODE
      instance_eval method, __FILE__, __LINE__
    end
  end
end