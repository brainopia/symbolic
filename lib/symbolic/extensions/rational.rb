# Fix for rational on 1.8.7
if RUBY_VERSION == '1.8.7'
  [Fixnum,Bignum].each do |klass|
    klass.class_eval do
      def rpower(other)
        if other.is_a?(Numeric) && other < 0
          Rational.new!(self, 1)**other
        else
          self.power!(other)
        end
      end
      alias ** rpower
    end # class_eval
  end # each
end # if