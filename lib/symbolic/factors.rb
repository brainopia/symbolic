require_relative 'abelian_group'
require_relative 'factor'

module Symbolic
  class Factors < AbelianGroup
    OPERATION = :*
    IDENTITY = 1

    AbelianGroup::MEMBERS[self] = Factor

    def simplify!
      super
      # {Factors <Factor -3>, <Factor <Summand x * -1>>} => {Factors <Factor 3>, <Factor x>}
    end

    # {Factors <Factor -1>, <Factor x>} => Summand x * -1
    def optimized
      return 0 if @members.any? { |m| m == 0 }

      #if @members.length >= 2 and @members[0] == 1
      #
      #end

      if @members.length == 2 and @members.all? { |m| Factor === m } and
          @members.find { |m| m == -1 } and (other = @members.find { |m| m != -1 }) # This final comparaison is too large
        #return Summand.new(other.base, -other.power)
      end
      super
    end
  end
end