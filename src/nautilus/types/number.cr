class Nautilus
  class Types
    class Number

      properties bytes : Byte
      properties carrier_bit : Int8

      def initialize(String number)
        value = number.hexbytes
      end

      def positive?
        carrier_bit == 1.to_i8
      end

      def negative?
        carrier_bit == -1.to_i8
      end

      def ==(other : self) : self
        bytes == other.bytes
      end

      def <(other : self) : self
        other > self
      end

      def >(other : self) : self
        if other.carrier_bit == self.carrier_bit
          (_gt(other) && !positive?)
        else
          positive?
        end
      end

      def - : self
        carrier_bit*=-1
      end

      def +(other : self) : self
        if(other.carrier_bit != other.carrier_bit
          self > other ? self - other : other - self
        elsif(other.carrier_bit == carrier_bit)
          return Nautilus::Types::Number.new( _add(a : Bytes, b : Bytes), carrier_bit)
        end
      end

      def -(other : self) : self
        if other.carrier_bit == self.carrier_bit || positive?
          return  other.negative? ? self + other : other + self
        else
          return  other.negative? ? Nautilus::Types::Number.new(_sub(other)) : other - self
        end
      end

      private def _sub(b : Bytes)
        (_abs(b), b > self ? -1.to_i8 : 1.to_i8 )
      end

      def _abs(b : Bytes) : Bytes
        a=bytes
        a,b = _swap(a,b) if (a.size() < b.size())
        l1 = a.size
        l2 = b.size
        carry : UInt8 = 0
        memory = Array(UInt8).new
        while (j >= 0)
          sum, carry = _sub(a[i], b[j])
          memory << (sum % 256)
          i -= 1
          j -= 1
        end
        while (i >= 0)
          sum, carry = _sub(a[i], b[j])
          memory << (sum % 256)
          i -= 1
        end
      end

      private def _gt(b : Bytes)
        (bytes.size > b.size) || (bytes.size == bytes.size && a[0] > b[0])
      end

      private def _add(b : Bytes)
        a = bytes
        _swap(a,b) if (a.size() < b.size())
        l1 = a.size
        l2 = b.size
        carry : UInt8 = 0
        memory = Array(UInt8).new
        while (j >= 0)
          sum, carry = _sub(a[i], b[j])
          memory << (sum % 256)
          i -= 1
          j -= 1
        end
        while (i >= 0)
          sum, carry = _sub(a[i], b[j])
          memory << (sum % 256)
          i -= 1
        end
      end

      private def _add(a : UInt8, b : UInt8, carry : UInt8) : (UInt8, UInt8)
          sum = a.to_u16 + b.to_u16 + carry.to_u16
          ( (sum % 256).to_u8, (sum / 256).to_u8 )
      end

      private def _sub(a: UInt8, b: UInt8 8) : (UInt8, UInt8)
        carry = 0
        if (a < b )
          carry = 1
          a,b = _swap(a,b)
        end
        diff = a - b
        (diff, carry)
      end

      private def _swap(a: UInt8, b: UInt8 8) : (UInt8, UInt8)
        (b, a)
      end

      private def _swap(a : Bytes, b : Bytes) : (Bytes, Bytes)
        (b, a)
      end

    end
  end
end
