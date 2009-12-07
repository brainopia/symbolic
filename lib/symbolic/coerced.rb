module Symbolic
  class Coerced
    def initialize(symbolic)
      @symbolic = symbolic
    end

    Symbolic.operations.each do |sign, name|
      method = <<-CODE
        def #{sign}(numeric)
          Optimization.#{name} numeric, @symbolic
        end
      CODE
      class_eval method, __FILE__, __LINE__
    end # Symbolic.operations.each
  end # Coerced
end # Symbolic