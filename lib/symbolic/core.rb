module Symbolic
  module Core
    @enabled = false

    class << self
      def enable
        if !@enabled
          @enabled = true
          redefine_numerical_methods
          redefine_math_methods
        end
      end

      def disable
        if @enabled
          @enabled = false
          restore_numerical_methods
          restore_math_methods
        end
      end

      private

      def numerical_eval(*args, &proc)
        [Fixnum, Bignum, Float].each do |klass|
          klass.class_eval *args, &proc
        end
      end

      def redefine_numerical_methods
        Symbolic.operations.each do |sign, name|
          numerical_eval numerical_method(sign,name), __FILE__, __LINE__
        end
      end

      def numerical_method(sign, name)
        <<-CODE
          alias non_symbolic_#{name} #{sign}

          def #{sign}(value)
            if value.symbolic?
              Optimization.#{name} self, value
            else
              non_symbolic_#{name}(value)
            end
          end
        CODE
      end

      def redefine_math_methods
        Symbolic.math_operations.each do |operation|
          Math.instance_eval math_method(operation), __FILE__, __LINE__
        end
      end

      def math_method(operation)
        <<-CODE
          alias non_symbolic_#{operation} #{operation}

          def #{operation}(value)
            if value.symbolic?
              Symbolic::Method.new value, :#{operation}
            else
              non_symbolic_#{operation} value
            end
          end
        CODE
      end

      def restore_numerical_methods
        numerical_eval do
          Symbolic.operations.each do |operation_sign, operation_name|
            alias_method operation_sign, "non_symbolic_#{operation_name}"
            remove_method "non_symbolic_#{operation_name}"
          end
        end
      end

      def restore_math_methods
        Math.module_eval do
          class << self
            Symbolic.math_operations.each do |operation|
              non_symbolic_operation = "non_symbolic_#{operation}"
              alias_method operation, non_symbolic_operation
              remove_method non_symbolic_operation
            end
          end
        end
      end
    end # class << self
  end # Core
end # Symbolic