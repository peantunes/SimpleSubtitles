import XCTest
import CoreMedia
@testable import SimpleSubtitles

final class WebVTTParserTests: XCTestCase {
    
    var sut: WebVTTParser!
    
    override func setUp() {
        super.setUp()
        sut = WebVTTParser()
    }
    
    func testParseContentFromFile() {
        guard let content = loadContent(file: "sample_split_lines.webvtt") else {
            XCTAssert(false, "failed")
            return
        }
        
        let subtitleInformation = sut.parse(string: content)
        
        XCTAssertNotNil(subtitleInformation)
        XCTAssertEqual(subtitleInformation?.sections.count, 1904)
    }
    
    func testParseContentWithMultipleLines() {
        let content: String = .multipleLineVTT
        
        let subtitleInformation = sut.parse(string: content)
        
        XCTAssertEqual(subtitleInformation?.sections.count, 2)
        let firstSection = subtitleInformation?.sections.first
        XCTAssertEqual(firstSection?.startTime, 20)
        XCTAssertEqual(firstSection?.endTime, 30)
        XCTAssertEqual(firstSection?.lines, "first line\nsecond line")
        
        let secondSection = subtitleInformation?.sections[1]
        XCTAssertEqual(secondSection?.startTime, 30)
        XCTAssertEqual(secondSection?.endTime, 50)
        XCTAssertEqual(secondSection?.lines, "other content\nanother line")
        
    }
    
    private func loadContent(file: String) -> String? {
        try? String(contentsOfFile: Resource(name: "sample_split_lines", type: "webvtt").url.path)
    }
}

private extension String {
    static let multipleLineVTT = """
0:00:20.000 --> 0:00:30.000
first line
second line

0:00:30.000 --> 0:00:50.000
other content
another line
"""
        
}

private struct Resource {
  let name: String
  let type: String
  let url: URL

  init(name: String, type: String, sourceFile: StaticString = #file) throws {
    self.name = name
    self.type = type

    let testCaseURL = URL(fileURLWithPath: "\(sourceFile)", isDirectory: false)
    let testsFolderURL = testCaseURL.deletingLastPathComponent()
    let resourcesFolderURL = testsFolderURL.deletingLastPathComponent().appendingPathComponent("SimpleSubtitles-Test/MockData", isDirectory: true)
    url = resourcesFolderURL.appendingPathComponent("\(name).\(type)", isDirectory: false)
  }
}
