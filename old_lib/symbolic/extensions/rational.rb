# Fix for Integer#** defined in stdlib rational.rb on ruby < 1.9
# We need to redefine Integer#**(other)
# Because, with Rational, it uses a comparaison such as other >= 0
# That cannot work with Symbolic::Variable (or make sense)
if RUBY_VERSION < '1.9'
  require 'rational'
  [Fixnum,Bignum].each do |klass|
    klass.class_eval do
      alias :old_power :**
      def **(other)
        if Numeric === other # If other is Numeric, we can use rpower(the new #** defined in stdlib rational.rb)
          old_power(other)
        else # But if not, we want the old behaviour(that was aliased to power!, and does not check if >= 0)
          power!(other)
        end
      end
    end # class_eval
  end # each
end # if