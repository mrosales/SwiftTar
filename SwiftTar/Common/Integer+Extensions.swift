import Foundation

extension UnsignedInteger {

    @inlinable @inline(__always)
    func toInt() -> Int {
        return Int(truncatingIfNeeded: self)
    }
}

extension Int {

    @inlinable @inline(__always)
    func roundTo512() -> Int {
        if self >= Int.max - 510 {
            return Int.max
        } else {
            return (self + 511) & (~511)
        }
    }

}
