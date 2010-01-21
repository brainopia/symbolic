# Fix for rational on 1.8.7
[Fixnum,Bignum].each do |klass|
  klass.class_eval do
    alias :old_power :**
    def **(other)
      if other.is_a?(Numeric) && other < 0
        Rational.new!(self, 1)**other
      else
        self.old_power(other)
      end
    end
  end
end