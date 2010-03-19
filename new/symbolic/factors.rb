module Symbolic
  class Factors < AbelianGroup
    OPERATION = :*
    IDENTITY = 1

    def simplify!
      super
      # {Factors <Factor -3>, <Factor <Summand x * -1>>} => {Factors <Factor 3>, <Factor x>}
    end

    # {Factors <Factor -1>, <Factor x>} => Summand x * -1
    def optimized
      if @members.length == 2 and @members.all? { |m| Factor === m } and @members.find { |m| m == -1 } # This final comparaison is too large
        p @members
        other = @members.find { |m| m != -1 }
        # return Summand.new(other.base, -other.power)
      end
      super
    end
  end
end