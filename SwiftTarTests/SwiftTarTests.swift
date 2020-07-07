//
//  SwiftTarTests.swift
//  SwiftTarTests
//
//  Created by Micah Rosales on 7/6/20.
//  Copyright © 2020 Micah Rosales. All rights reserved.
//

import XCTest
@testable import SwiftTar

class SwiftTarTests: XCTestCase {
  lazy var bundle: Bundle = { Bundle(for: Self.self) }()

  func data(forResource resource: String, withExtension ext: String) -> Data {
    guard let url = bundle.url(forResource: resource, withExtension: ext) else {
      preconditionFailure()
    }
    guard let data = try? Data(contentsOf: url) else {
      preconditionFailure()
    }
    return data
  }

  func testFileDirectorySymlink() throws {
    let archive = try TarContainer.open(container: data(forResource: "file_directory_symlink", withExtension: ".tar"))

    XCTAssertEqual(archive.count, 5)

    archive.enumerated().forEach {
      let info = $0.element.info
      let data = $0.element.data

      switch $0.offset {
      case 0:
        XCTAssertEqual(info.type, .directory)
        XCTAssertEqual(info.name, "directory/")
        XCTAssertEqual(info.size, 0)

      case 1:
        XCTAssertEqual(info.type, .directory)
        XCTAssertEqual(info.name, "directory/nested/")
        XCTAssertEqual(info.size, 0)

      case 2:
        XCTAssertEqual(info.type, .regular)
        XCTAssertEqual(info.name, "directory/nested/regular_file.txt")
        XCTAssertEqual(info.size, 22)
        let contents = data!.utf8EncodedString
        XCTAssertEqual(contents, "regular file contents\n")

      case 3:
        XCTAssertEqual(info.type, .hardLink)
        XCTAssertEqual(info.name, "regular_hard.txt")
        XCTAssertEqual(info.linkName, "directory/nested/regular_file.txt")
        XCTAssertEqual(info.size, 0)

      case 4:
        XCTAssertEqual(info.type, .symbolicLink)
        XCTAssertEqual(info.name, "regular_symbolic.txt")
        XCTAssertEqual(info.linkName, "directory/nested/regular_file.txt")
        XCTAssertEqual(info.size, 0)

      default:
        XCTFail("unexpected block at index: \($0.offset)")
      }
    }
  }
}

extension Data {
  var utf8EncodedString: String {
    guard let string = String(data: self, encoding: .utf8) else { preconditionFailure() }
    return string
  }
}

extension Encodable {
  var prettyJSONString: String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    guard let encoded = try? encoder.encode(self) else { preconditionFailure() }
    return encoded.utf8EncodedString
  }
}
