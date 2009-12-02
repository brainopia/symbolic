module Symbolic
  class Operatable
    def -@
      UnaryMinus.create self
    end

    def +@
      self
    end

    Symbolic.operations.each do |operation_sign, operation_name|
      method = <<-CODE
        def #{operation_sign}(value)
          Optimizations.#{operation_name} self, value
        end
      CODE
      class_eval method, __FILE__, __LINE__
    end

    def undefined?
      !value
    end

    def symbolic?
      true
    end
  end
end