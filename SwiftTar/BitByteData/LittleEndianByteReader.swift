import Foundation

/// A type that contains functions for reading `Data` byte-by-byte in the Little endian order.
public final class LittleEndianByteReader: ByteReader {

    /// Size of the `data` (in bytes).
    public let size: Int

    /// Data which is being read.
    public let data: Data

    /// Offset to the byte in `data` which will be read next.
    public var offset: Int

    /// Creates an instance for reading bytes from `data`.
    public init(data: Data) {
        self.size = data.count
        self.data = data
        self.offset = data.startIndex
    }

    /**
     Reads byte and returns it, advancing by one position.

     - Precondition: There MUST be enough data left.
     */
    public func byte() -> UInt8 {
        return { (data: Data, offset: inout Int) -> UInt8 in
            defer { offset += 1 }
            return data[offset]
        } (self.data, &self.offset)
    }

    /**
     Reads `count` bytes and returns them as an array of `UInt8`, advancing by `count` positions.

     - Precondition: Parameter `count` MUST not be less than 0.
     - Precondition: There MUST be enough data left.
     */
    public func bytes(count: Int) -> [UInt8] {
        precondition(count >= 0)
        return { (data: Data, offset: inout Int) -> [UInt8] in
            defer { offset += count }
            return data[offset..<offset + count].toByteArray(count)
        } (self.data, &self.offset)
    }

    /**
     Reads `fromBytes` bytes and returns them as an `Int` number, advancing by `fromBytes` positions.

     - Precondition: Parameter `fromBytes` MUST not be less than 0.
     - Precondition: There MUST be enough data left.
     */
    public func int(fromBytes count: Int) -> Int {
        precondition(count >= 0)
        // TODO: If uintX() could be force inlined or something in the future then probably it would make sense
        // to use them for `count` == 2, 4 or 8.
        return { (data: Data, offset: inout Int) -> Int in
            var result = 0
            for i in 0..<count {
                result += Int(truncatingIfNeeded: data[offset]) << (8 * i)
                offset += 1
            }
            return result
        } (self.data, &self.offset)
    }

    /**
     Reads `fromBytes` bytes and returns them as an `UInt64` number, advancing by `fromBytes` positions.

     - Note: If it is known that `fromBytes` is exactly 8, then consider using `uint64()` function (without argument),
     since it has better performance in this situation.
     - Precondition: Parameter `fromBits` MUST be from `0..8` range, i.e. it MUST not exceed maximum possible amount of
     bytes that `UInt64` type can represent.
     - Precondition: There MUST be enough data left.
     */
    public func uint64(fromBytes count: Int) -> UInt64 {
        precondition(0...8 ~= count)
        return { (data: Data, offset: inout Int) -> UInt64 in
            var result = 0 as UInt64
            for i in 0..<count {
                result += UInt64(truncatingIfNeeded: data[offset]) << (8 * i)
                offset += 1
            }
            return result
        } (self.data, &self.offset)
    }

}
