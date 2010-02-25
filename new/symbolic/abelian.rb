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
      unless self.class == Abelian
        @base.value.send(OPERATORS_RISING[operation], @power.value)
      else
        if @power == 1
          @base.value
        else
          raise
        end
      end
    end
    
    # Create a new element with old |base, power|
    def new
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
          raise "Abelian with power != 1(#{@power}) with no operation: #{super}"
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
      @base == object.base and @power == object.power rescue false
    end

    class << self
      alias :_new :new
      def new(*args)
        if args.length == 1 and (self === args[0] or AbelianGroup === args[0]) # Already a subclass of Abelian or an AbelianGroup
          args[0]
        elsif args.length == 1 and Abelian == args[0].class and self != Abelian # an Abelian, undeterminated
          self.new(args[0].base, args[0].power)
        else
          _new(*args)
        end
      end
    end
  end
end
