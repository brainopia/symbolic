module Symbolic
  def self.Numeric(value)
    Numeric.new value
  end

  class Numeric
    include Symbolic
    attr_reader :value

    def initialize(value)
      @value = value
    end
  end
end
