module Symbolic
  class Coerced
    def initialize(symbolic)
      @symbolic = symbolic
    end

    Operations.binary.each do |sign, name|
      method = <<-CODE
        def #{sign}(numeric)
          Optimization.#{name} numeric, @symbolic
        end
      CODE
      class_eval method, __FILE__, __LINE__
    end # Operations.binary.each
  end # Coerced
end # Symbolic