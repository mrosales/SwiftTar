import Foundation

internal extension Data {

    @inlinable @inline(__always)
    func toU16() -> UInt16 {
        return self.withUnsafeBytes { $0.bindMemory(to: UInt16.self)[0] }
    }

    @inlinable @inline(__always)
    func toU32() -> UInt32 {
        return self.withUnsafeBytes { $0.bindMemory(to: UInt32.self)[0] }
    }

    @inlinable @inline(__always)
    func toU64() -> UInt64 {
        return self.withUnsafeBytes { $0.bindMemory(to: UInt64.self)[0] }
    }

    @inlinable @inline(__always)
    func toByteArray(_ count: Int) -> [UInt8] {
        return self.withUnsafeBytes { $0.map { $0 } }
    }

}
