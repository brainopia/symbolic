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
    def enabled?
      @enabled
    end

    def enable
      return if @enabled
      @enabled = true
      numerical_context do
        Symbolic.aliases.each do |standard_operation, non_symbolic_operation|
          alias_method non_symbolic_operation, standard_operation
        end

        def *(value)
          if value.is_a?(Operatable)
            Optimizations.multiply value, self, :reverse
          else
            non_symbolic_multiplication(value)
          end
        end

        def +(value)
          if value.is_a? Operatable
            Optimizations.plus value, self, :reverse
          else
            non_symbolic_addition value
          end
        end

        def -(value)
          if value.is_a? Operatable
            Optimizations.minus value, self, :reverse
          else
            non_symbolic_substraction value
          end
        end
      end # numerical_context

      math_operations.each do |operation|
        Math.module_eval <<-CODE
          class << self
            alias non_symbolic_#{operation} #{operation}

            def #{operation}(value)
              if value.is_a? Operatable
                Symbolic::Method.new value, :#{operation}
              else
                non_symbolic_#{operation} value
              end
            end
          end
        CODE
      end
    end # enable

    def disable
      return if !@enabled
      @enabled = false
      numerical_context do
        Symbolic.aliases.each do |standard_operation, non_symbolic_operation|
          alias_method standard_operation, non_symbolic_operation
          remove_method non_symbolic_operation
        end
      end

      Math.module_eval do
        class << self
          Symbolic.math_operations.each do |operation|
            non_symbolic_operation = "non_symbolic_#{operation}"
            alias_method operation, non_symbolic_operation
            remove_method non_symbolic_operation
          end
        end
      end
    end # disable

    def aliases
      { :* => :non_symbolic_multiplication,
        :+ => :non_symbolic_addition,
        :- => :non_symbolic_substraction }
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
  end # class << self
end