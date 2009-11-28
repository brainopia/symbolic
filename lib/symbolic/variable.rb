module Symbolic
  class Variable < Operatable
    attr_accessor :value, :name

    def initialize(options)
      @name, @value = options.values_at(:name, :value)
    end

    def to_s
      @name || 'unnamed_variable'
    end

    def undefined_variables
      @value ? [] : [self]
    end
  end
end