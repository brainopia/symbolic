Dir[File.expand_path('../symbolic/**/*.rb', __FILE__)].each(&method(:require))

module Symbolic
  class AbelianGroup
    MEMBERS = { Summands => Summand, Factors => Factor}
  end

  module Operators
    OPERATORS_GROUPS = {
      :+ => Summands,
      :- => Summands,
      :* => Factors,
      :/ => Factors,
      :** => Factors
    }
  end
end
