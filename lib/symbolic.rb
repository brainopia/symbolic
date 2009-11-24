require 'symbolic/operatable'
require 'symbolic/optimizations'
require 'symbolic/variable'
require 'symbolic/expression'
require 'symbolic/method'
require 'symbolic/unary_minus'
require 'extensions/kernel'

module Symbolic
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

    def aliases
      { :* => :multiplication,
        :+ => :addition,
        :- => :subtraction }
    end

    def math_operations
      [:cos, :sin]
    end

    private

    def numerical_context(&proc)
      [Fixnum, Bignum, Float].each do |klass|
        klass.class_eval &proc
      end
    end

    def redefine_numerical_methods
      numerical_context do
        Symbolic.aliases.each do |operation_sign, operation_name|
          alias_method "non_symbolic_#{operation_name}", operation_sign

          method = <<-CODE
            def #{operation_sign}(value)
              if value.is_a?(Operatable)
                Optimizations.#{operation_name} value, self, :reverse
              else
                non_symbolic_#{operation_name}(value)
              end
            end
          CODE

          class_eval method, __FILE__, __LINE__
        end
      end # numerical_context
    end # redefine_numerical_methods

    def redefine_math_methods
      math_operations.each do |operation|
        code = <<-CODE
          alias non_symbolic_#{operation} #{operation}

          def #{operation}(value)
            if value.is_a? Operatable
              Symbolic::Method.new value, :#{operation}
            else
              non_symbolic_#{operation} value
            end
          end
        CODE
        Math.instance_eval code, __FILE__, __LINE__
      end
    end # redefine_math_methods

    def restore_numerical_methods
      numerical_context do
        Symbolic.aliases.each do |operation_sign, operation_name|
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
end