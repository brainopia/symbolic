module Symbolic
  # This class is used to create symbolic variables.
  class Variable
    include Symbolic
    attr_accessor :name, :proc
    attr_writer :value

    def initialize(options={}, &proc)
      @name, @value = options.values_at(:name, :value)
      @name = @name.to_s if @name
      @proc = proc
    end

    def value
      @value || @proc && @proc.call.value
    end

    def to_s
      @name || 'unnamed_variable'
    end

    def variables
      [self]
    end
  end
end