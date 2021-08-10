import XCTest
import SubtitlesInterface
@testable import SimpleSubtitles

final class SubtitlesControlInteractorTests: XCTestCase {
    
    var subtitlesParserMock: SubtitlesParserMock!
    var fileLoaderMock: FileLoaderMock!
    
    override func setUp() {
        super.setUp()
        subtitlesParserMock = SubtitlesParserMock()
        fileLoaderMock = FileLoaderMock()
    }
    
    func testLoadFileAndParse() {
        // given
        fileLoaderMock.stubString = "My content to parse"
        let sut = SubtitlesInteractor(parser: subtitlesParserMock, fileLoader: fileLoaderMock, options: .init())
        
        // when
        sut.setSubtitleFile(url: "anyfile")
        
        // then
        XCTAssertEqual(fileLoaderMock.log, [.loadStringFile(url: "anyfile")])
        XCTAssertEqual(subtitlesParserMock.log, [.parse(string: "My content to parse")])
        
    }
    
    func testFoundFirstSectionInsideTime() {
        // given
        subtitlesParserMock.stubResponseInformation = .twoSectionsWithSameEndAndStartValue
        let firstSection = SubtitleInformation.twoSectionsWithSameEndAndStartValue.sections.first
        let sut = SubtitlesInteractor(parser: subtitlesParserMock, fileLoader: fileLoaderMock, options: .init())
        sut.setSubtitleFile(url: "anyfile")
        
        // when
        let sectionWithTimeZero = sut.sectionFromTime(1)
        let sectionWithTimeTwo = sut.sectionFromTime(2)
        
        // then
        XCTAssertEqual(sectionWithTimeZero, firstSection)
        XCTAssertEqual(sectionWithTimeTwo, firstSection)
    }
    
    func testFoundSecondSectionWhenEndTimeAndStartTimeAreTheSame() {
        // given
        subtitlesParserMock.stubResponseInformation = .twoSectionsWithSameEndAndStartValue
        let secondSection = SubtitleInformation.twoSectionsWithSameEndAndStartValue.sections[1]
        let sut = SubtitlesInteractor(parser: subtitlesParserMock, fileLoader: fileLoaderMock, options: .init())
        sut.setSubtitleFile(url: "anyfile")
        
        // when
        let section = sut.sectionFromTime(12)
        
        // then
        XCTAssertEqual(section, secondSection)
    }
    
    func testNotFoundSectionForTheTime() {
        // given
        subtitlesParserMock.stubResponseInformation = .twoSectionsWithSameEndAndStartValue
        let sut = SubtitlesInteractor(parser: subtitlesParserMock, fileLoader: fileLoaderMock, options: .init())
        sut.setSubtitleFile(url: "anyfile")
        
        // when
        let section = sut.sectionFromTime(20)
        
        // then
        XCTAssertNil(section)
    }
    
    func testBackwardTimeFindCorrectSection() {
        subtitlesParserMock.stubResponseInformation = .sectionsWithTenSecondsAndTwoSecondsInterval
        let sections = subtitlesParserMock.stubResponseInformation?.sections
        let sut = SubtitlesInteractor(parser: subtitlesParserMock, fileLoader: fileLoaderMock, options: .init())
        sut.setSubtitleFile(url: "anyfile")
        
        // then
        var resultSection = sut.sectionFromTime(62)
        XCTAssertNotNil(resultSection)
        XCTAssertEqual(resultSection, sections?[6])
        
        resultSection = sut.sectionFromTime(18)
        XCTAssertNotNil(resultSection)
        XCTAssertEqual(resultSection, sections?[1])
        
        resultSection = sut.sectionFromTime(81)
        XCTAssertNil(resultSection)
        
        resultSection = sut.sectionFromTime(83)
        XCTAssertNotNil(resultSection)
        XCTAssertEqual(resultSection, sections?[8])
    }
}

private extension SubtitleInformation {
    static let twoSectionsWithSameEndAndStartValue: SubtitleInformation = {
        let firstSection: SubtitleInformation.Section = .init(startTime: 0, endTime: 12, lines: "Hi")
        let secondSection: SubtitleInformation.Section = .init(startTime: 12, endTime: 20, lines: "Hello")
        
        return SubtitleInformation(sections: [firstSection, secondSection])
    } ()
    
    static let sectionsWithTenSecondsAndTwoSecondsInterval: SubtitleInformation = {
        var sections: [SubtitleInformation.Section] = []
        for index in 1...10 {
            sections.append(SubtitleInformation.Section(startTime: Double(index-1)*10+2, endTime: Double(index) * 10, lines: "My section \(index)"))
        }
        
        return SubtitleInformation(sections: sections)
    } ()
}
