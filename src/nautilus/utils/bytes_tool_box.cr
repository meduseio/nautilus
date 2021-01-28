module Nautilus
  module Utils
    class BytesToolBox

      def self.concat(a : Bytes, b : Bytes)
        result = IO::Memory.new a.bytesize + b.bytesize
        a.each do |v|
            result.write_bytes UInt8.new v
        end
        b.each do |v|
            result.write_bytes UInt8.new v
        end
        result.to_slice
      end

      def self.convert_array_to_bytes(action = Array(Int32))
        slice = Bytes.new(action.size)
        action.each_with_index do |v, index|
          slice[index] = UInt8.new(v)
        end
        slice
      end

      def self.build_unknown_message_length_bytes(message)
        sliced_message = message.to_slice
        size = sliced_message.size.to_u
        size_slice = Nautilus::Utils::BytesToolBox.convert_uint32_to_bytes(UInt32.new(size))
        Nautilus::Utils::BytesToolBox.concat(size_slice, sliced_message)
      end

      def self.convert_bytes_to_uint32(bytes : Bytes) : UInt32
        IO::ByteFormat::BigEndian.decode(UInt32, bytes)
      end

      def self.convert_uint32_to_bytes(number : UInt32) : Bytes
        raw = uninitialized UInt8[4]
        IO::ByteFormat::BigEndian.encode(number, raw.to_slice)
        slice = Bytes.new(4)
        raw.each_with_index do |v, index|
          slice[index] = UInt8.new(v)
        end
        slice
      end

      def self.read_string_from_bytes(bytes : Bytes) : Tuple(String, Bytes)
        message_length = Nautilus::Utils::BytesToolBox.convert_bytes_to_uint32(bytes[0, 4])
        message_bytes = bytes+4
        { String.new(slice: message_bytes[0, message_length]), message_bytes+message_length }
      end

    end
  end
end
