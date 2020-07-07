import Foundation

/// A type that represents an archive.
public protocol Archive {

    /// Unarchive data from the archive.
    static func unarchive(archive: Data) throws -> Data

}
