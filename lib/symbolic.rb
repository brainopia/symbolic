module Symbolic
  @enabled = false
  class << self
    def enabled?
      @enabled
    end

    def enabled=(enable_flag)
      if enable_flag && !@enabled
        enable
      elsif !enable_flag && @enabled
        disable
      end
    end

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

    def enable
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
  end # class << self

  class Operatable
    def -@
      UnaryMinus.create self
    end

    def *(value)
      Optimizations.multiply self, value
    end

    def +(value)
      Optimizations.plus self, value
    end

    def -(value)
      Optimizations.minus self, value
    end
  end # Operations

  module Optimizations
    def self.plus(symbolic_var, var, reverse=false)
      if var == 0
        symbolic_var
      elsif var.is_a? UnaryMinus
        symbolic_var - var.variable
      elsif reverse && symbolic_var.is_a?(UnaryMinus)
        var - symbolic_var.variable
      else
        if reverse
          Expression.new var, symbolic_var, '+'
        else
          Expression.new symbolic_var, var, '+'
        end
      end
    end

    def self.minus(symbolic_var, var, reverse=false)
      if var == 0
        symbolic_var
      elsif var.is_a? UnaryMinus
        symbolic_var + var.variable
      elsif reverse && symbolic_var.is_a?(UnaryMinus)
        var + symbolic_var.variable
      else
        if reverse
          Expression.new var, symbolic_var, '-'
        else
          Expression.new symbolic_var, var, '-'
        end
      end
    end

    def self.multiply(symbolic_var, var, reverse=false)
      if var == 0
        var
      elsif var == 1
        symbolic_var
      elsif var == -1
        -symbolic_var
      elsif var.is_a?(Numeric) && var < 0
        -(-var*symbolic_var)
      elsif var.is_a? UnaryMinus
        UnaryMinus.create symbolic_var*var.variable
      elsif symbolic_var.is_a? UnaryMinus
        UnaryMinus.create symbolic_var.variable*var
      else
        if reverse
          Expression.new var, symbolic_var, '*'
        else
          Expression.new symbolic_var, var, '*'
        end
      end
    end
  end

  class Variable < Operatable
    attr_accessor :value

    @@index = 0

    def initialize(options)
      unless @name = options[:name]
        @@index += 1
        @name = "var#{@@index}"
      end

      @value = options[:value]
    end

    def to_s
      @name
    end

    def undefined_variables
      @value ? [] : [self]
    end
  end

  class Expression < Operatable
    def initialize(var1, var2, operation)
      @var1, @var2, @operation = var1, var2, operation
    end

    def to_s
      var1 = "#{@var1}"
      var2 = "#{@var2}"
      if @operation == '*'
        var1 = "(#{@var1})" if @var1.is_a?(Expression) && (@var1.plus? || @var1.minus?)
        var2 = "(#{@var2})" if @var2.is_a?(Expression) && (@var2.plus? || @var1.minus?)
      end
      "#{var1}#{@operation}#{var2}"
    end

    def plus?
      @operation == '+'
    end

    def minus?
      @operation == '-'
    end

    def multiply?
      @operation == '*'
    end

    def value
      if undefined_variables.empty?
        value_of(@var1).send @operation, value_of(@var2)
      end
    end

    def undefined_variables
      (undefined_variables_of(@var1) + undefined_variables_of(@var2)).uniq
    end

    private

    def undefined_variables_of(variable)
      variable.is_a?(Operatable) ? variable.undefined_variables : []
    end

    def value_of(variable)
      variable.is_a?(Operatable) ? variable.value : variable
    end
  end

  class Method < Operatable
    def initialize(variable, operation)
      @variable, @operation = variable, operation
    end

    def to_s
      "#{@operation}(#{@variable})"
    end

    def value
      Math.send @operation, @variable.value if undefined_variables.empty?
    end

    def undefined_variables
      @variable.undefined_variables
    end
  end

  class UnaryMinus < Operatable
    attr_reader :variable

    def self.create(expression)
      if expression.is_a? UnaryMinus
        expression.variable
      else
        new expression
      end
    end

    def initialize(variable)
      @variable = variable
    end

    def to_s
      if @variable.is_a? Variable
        "-#{@variable}"
      else
        "(-#{@variable})"
      end
    end

    def value
      -@variable.value if undefined_variables.empty?
    end

    def undefined_variables
      @variable.undefined_variables
    end
  end
end

module Kernel
  def var(options={})
    Symbolic::Variable.new options
  end

  def symbolic
    Symbolic.enabled = true
    yield
    Symbolic.enabled = false
  end
end