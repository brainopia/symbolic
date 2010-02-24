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
      #if self.class === base
      #  @base, @power = base.base, base.power * power
      #else
        @base, @power = base, power
      #end
    end
    
    def value
      group = block_given? ? yield : nil
      if !group.nil?
        @base.value.send(OPERATORS_RISING[group.operation], @power.value)
      else
        if @power.one?
          @base.value
        else
          raise
        end
      end
    end

    # def operation
    #   self.class::OPERATION
    # end
    # def identity
    #   self.class::IDENTITY
    # end
    
    # Create a new element with old |base, power|
    def new
      self.class.new *yield(@base, @power)
    end
    
    #TEMP
    def to_s
      group = block_given? ? yield : nil
      simplify!(group)
      "<#{self.class.simple_name} #{@base}#{
        " #{OPERATORS_RISING[group.operation]} #{@power}" if !@power.one? and !group.nil?
        # " #{@power}" unless @power.one?
      }>"
    end
    
    def simplify!(group)
      if Numeric === @power and @power < 0 and !group.nil?
        if group.operation == :+ and @base.respond_to?(:-@)
          @base, @power = -@base, -@power
        elsif group.operation == :*
          @base, @power = Rational(1, @base), -@power
        end
      end
    end

#    def coerce(numeric)
#      [Coerced.new(self), numeric]
#    end

    class << self
      alias :_new :new
      def new(*args)
        if args.length == 1 and (self === args[0] or AbelianGroup === args[0])
          args[0]
        else
          _new(*args)
        end
      end
    end
  end
end
