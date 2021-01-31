module Nautilus
  module Utils
    class HexMath
      HEX_VALUE_OF_DEC  = {
        '0' => 0, '1' => 1,
        '2' => 2, '3' => 3,
        '4' => 4, '5' => 5,
        '6' => 6, '7' => 7,
        '8' => 8, '9' => 9,
        'A' => 10, 'B' => 11,
        'C' => 12, 'D' => 13,
        'E' => 14, 'F' => 15
      }
      DEC_VALUE_OF_HEX = {
        0 => '0', 1 => '1',
        2 => '2', 3 => '3',
        4 => '4', 5 => '5',
        6 => '6', 7 => '7',
        8 => '8', 9 => '9',
        10 => 'A', 11 => 'B',
        12 => 'C', 13 => 'D',
        14 => 'E', 15 => 'F'
      }

      def self.add(a : String, b : String) : String
        if (a.size() < b.size())
          t = a
          a = b
          b = t
        end
        m = HEX_VALUE_OF_DEC
        k = DEC_VALUE_OF_HEX
        l1 = a.size
        l2 = b.size
        i = l1 - 1;
        j = l2 - 1;
        carry = 0
        sum = 0
        builder = String::Builder.new
        while (j >= 0)
          sum = m[a[i]] + m[b[j]] + carry;
          addition_bit = k[sum % 16];
          builder << addition_bit;
          carry = (sum / 16).to_i;
          i -= 1
          j -= 1
        end
        while (i >= 0)
          sum = m[a[i]] + carry;
          addition_bit = k[sum % 16];
          builder << addition_bit;
          carry = (sum / 16).to_i;
          i -= 1
        end
        builder << k[carry] if (carry > 0)
        builder.to_s.reverse
      end
    end
  end
end
