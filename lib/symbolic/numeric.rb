require 'delegate'

module Symbolic
  def self.Numeric(value)
    Numeric.new value
  end

  class Numeric < DelegateClass(Numeric)
    def initialize(value)
      super value
    end

    def variables
      []
    end
  end
end
