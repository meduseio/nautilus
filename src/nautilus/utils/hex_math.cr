module Nautilus
  module Utils
    class HexMath

      private def self._swap(a: UInt8, b: UInt8 8) : (UInt8, UInt8)
        (b, a)
      end

      private def self._swap(a : Bytes, b : Bytes) : (Bytes, Bytes)
        (b, a)
      end

      private def self._sub(a: UInt8, b: UInt8 8) : (UInt8, UInt8)
        carry = 0
        if (a < b )
          carry = 1
          a,b = _swap(a,b)
        end
        diff = a - b
        (diff, carry)
      end

      def self.abs(a : Bytes, b : Bytes) : Bytes
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
      def self.add(a : Bytes, b : Bytes) : Bytes
        _swap(a,b) if (a.size() < b.size())
        l1 = a.size
        l2 = b.size
        i = l1 - 1;
        j = l2 - 1;
        carry : UInt8 = 0
        memory = Array(UInt8).new
        while (j >= 0)
          sum = a[i] + b[j] + carry
          memory << (sum % 256)
          carry = (sum / 256).to_u8
          i -= 1
          j -= 1
        end
        while (i >= 0)
          sum = a[i] + carry
          memory << (sum % 256)
          carry = (sum / 256).to_u8
          i -= 1
        end
        memory << carry.to_u8 if (carry > 0)
        BytesToolBox.convert_array_to_bytes(memory.reverse)
      end

      def sub(a : Bytes, b : Bytes)  : Bytes
        if(b.size() > a.size() || b[0] > a[0])
          raise "Second Value is bigger"
        end
        l1 = a.size
        l2 = b.size
        i = l1 - 1;
        j = l2 - 1;
        carry : UInt8 = 0
        memory = Array(UInt8).new
        while (j >= 0)
          subt = 0.to_u8
          if((a[i] + carry) => b [i])
            subt = a[i] - b [i]
          else()
        end
      end

      def self.add(a : String, b : String) : String
        add(a.downcase.hexbytes,b.downcase.hexbytes).hexstring
      end
    end
  end
end
