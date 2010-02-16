require 'delegate'

module Symbolic
  class Numeric < DelegateClass(Numeric)
    def initialize(value)
      super value
    end

    def variables
      []
    end
  end
end
