module Symbolic
  class Variable < Operatable
    attr_accessor :value, :name

    @@index = 0

    def initialize(options)
      unless @name = options[:name].to_s
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
end