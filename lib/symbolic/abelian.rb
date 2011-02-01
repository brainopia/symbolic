require_relative 'operators'

module Symbolic
  # Basically, we have two main operations: + and *
  # They are the two Abelian groups:
  #    Op | Identity | PowerOp | Inverse
  # a + b | 0        | *       | -a
  # a * b | 1        | **      | 1/a
  class Abelian
    include Operators

    attr_reader :base, :power
    # 1:base, 2:power
    # For * : ... * (1 ** 2) * ...
    # For + : ... + (1 *  2) + ...
    def initialize(base, power = 1)
      if base.class == self.class and !base.power.nil?
        @base, @power = base.base, base.power * power
      else
        @base, @power = base, power
      end
      simplify!
    end

    def value
      if self.class != Abelian
        @base.value.send(OPERATORS_RISING[operation], @power.value) rescue nil
      else
        if @power == 1
          @base.value
        else
          raise "Can't know value of #{self} because @power != 1 and self is an undeterminated Abelian"
        end
      end
    end

    # Create a new element with old |base, power|
    def renew
      Abelian.new(*yield(@base, @power))
    end

    #TEMP
    def to_s
      # simplify!
      s = "<#{self.class.simple_name} #{@base}"
      unless @power == 1
        if self.respond_to? :operation
          s << " #{OPERATORS_RISING[operation]} #{@power}"
        else
          raise "Abelian with power != 1(#{@power}) with no operation: <#{self.class.simple_name} @base=#{@base} @power=#{@power}>"
        end
      end
      s << ">"
    end

    def simplify!
      # @power
      if Numeric === @power and @power < 0
        if Summand === self and @base.respond_to?(:-@)
          @base, @power = -@base, -@power
        elsif Factor === self and Numeric === @base
          @base, @power = Rational(1, @base), -@power
        end
      end
    end

    def numeric?
      Numeric === @base and Numeric === @power
    end

    def == object
      if Abelian === object
        @base == object.base and @power == object.power # rescue false
      elsif Numeric === object
        self.value == object
      else
        false
      end
    end

    def optimized
      if @power == 1
        @base
      else
        self
      end
    end

    class << self
      def new(*args)
        if args.length == 1
          o = args[0]
          if o.class == Variable
            return super(o)
          elsif o.class == Abelian # an Abelian, undeterminated
            return super(o.base, o.power) # We cast it in the right subclass
          elsif self === o or AbelianGroup === o # Already a subclass of Abelian or an AbelianGroup
            return o
          end
        end

        #if self == Summand and args.length == 2 and args[1] != 1
        #  p :bad
        #  #return Factors.new(*args) # We don't want power for Summand!
        #  return super(*args)
        #end

        super(*args)
      end
    end
  end
end
