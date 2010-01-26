# Fix for rational on 1.8.7
if RUBY_VERSION == '1.8.7'
  require 'rational'
  [Fixnum,Bignum].each do |klass|
    klass.class_eval do
      # this method is copy-pasted from ruby std, the only change is conditional for Numeric
      remove_method :**
      def **(other)
        if other.is_a?(Numeric) && other < 0
          Rational.new!(self, 1)**other
        else
          power!(other)
        end
      end
    end # class_eval
  end # each
end # if