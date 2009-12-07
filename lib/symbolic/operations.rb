module Symbolic
  module Operations
    def self.binary
      { :* => :multiplication,
        :+ => :addition,
        :- => :subtraction,
        :/ => :division }
    end

    def -@
      Operation::Unary::Minus.for self
    end

    def +@
      self
    end

    binary.each do |sign, name|
      method = <<-CODE
        def #{sign}(value)
          Optimization.#{name} self, value
        end
      CODE
      class_eval method, __FILE__, __LINE__
    end

    def coerce(numeric)
      return Coerced.new(self), numeric
    end

    def operations
      detailed_operations.values.inject(0) {|sum,it| sum + it }
    end
  end
end