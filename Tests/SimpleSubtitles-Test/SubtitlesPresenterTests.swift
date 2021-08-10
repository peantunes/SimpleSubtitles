import XCTest
import CoreMedia
@testable import SimpleSubtitles

final class SubtitlesPresenterTests: XCTestCase {
    
    var playerMock: PlayerControlMock!
    var interactorMock: SubtitlesInteractorMock!
    var viewMock: SubtitlesControlViewMock!
    
    var sut: SubtitlesControlPresenter!
    
    override func setUp() {
        super.setUp()
        playerMock = PlayerControlMock()
        interactorMock = SubtitlesInteractorMock()
        viewMock = SubtitlesControlViewMock()
        
        sut = SubtitlesControlPresenter(player: playerMock, interactor: interactorMock)
        sut.view = viewMock
    }
    
    func testCallTimeObserver() {
        XCTAssertEqual(playerMock.logs, [.addPeriodicTimeObserver])
    }
    
    func testPlayerCallsTimeUpdate() {
        interactorMock.stubSections = [.init(startTime: 0, endTime: 10, lines: "123")]
        playerMock.mockBlock(time: .zero)
        
        XCTAssertEqual(viewMock.logs, [.showSubtitles(.init(lines: "123"))])
    }
    
    func testSetLanguage() {
        sut.setLanguage(url: "MyFile")
        
        XCTAssertEqual(interactorMock.logs, [.setSubtitleFile(url: "MyFile")])
    }
    
    func testTimeUpdateWithSection() {
        interactorMock.stubSections = [.init(startTime: 0, endTime: 10, lines: "My Lines")]
        
        sut.timeUpdate(.withSeconds(3))
        
        XCTAssertEqual(viewMock.logs, [.showSubtitles(.init(lines: "My Lines"))])
    }
    
    func testTimeUpdateWithMultipleSections() {
        interactorMock.stubSections = [.init(startTime: 0, endTime: 10, lines: "My First line"),
                                       .init(startTime: 0, endTime: 10, lines: "My Second line"),
                                       .init(startTime: 0, endTime: 10, lines: "My Third line")]
        
        sut.timeUpdate(.withSeconds(3))
        
        XCTAssertEqual(viewMock.logs, [.showSubtitles(.init(lines: "My First line\nMy Second line\nMy Third line"))])
    }
    
    func testTimeUpdateHideSubtitlesWhenNoSectionFound() {
        interactorMock.stubSection = nil
        
        sut.timeUpdate(.withSeconds(1))
        
        XCTAssertEqual(viewMock.logs, [.hideSubtitles])
    }
    
    func testOffSubtitlesWhtTimeUpdateDoesntPerformUpdate() {
        sut.turnOff()
        viewMock.logs = []
        
        sut.timeUpdate(.withSeconds(1))
        
        XCTAssertEqual(viewMock.logs, [])
        
    }
    
    func testTurnOffSubtitles() {
        sut.turnOff()
        
        XCTAssertEqual(viewMock.logs, [.hideSubtitles])
    }
    
    func testSetLanguageAfterTurnedOffWillTurnOnSubtitles() {
        interactorMock.stubSections = [.init(startTime: 0, endTime: 10, lines: "123")]
        sut.turnOff()
        
        sut.setLanguage(url: "MyFile")
        sut.timeUpdate(.withSeconds(1))
        
        XCTAssertEqual(viewMock.logs, [.hideSubtitles, .showSubtitles(.init(lines: "123"))])
        XCTAssertEqual(interactorMock.logs, [.setSubtitleFile(url: "MyFile"), .sectionsFromTime(1)])
    }
    
    func testWhenRemoveInstanceItCallsRemoveTimeObserver() {
        playerMock.logs = []
        
        sut = nil
        
        XCTAssertEqual(playerMock.logs, [.removeTimeObserver])
    }
}

private extension CMTime {
    static func withSeconds(_ seconds: Double) -> CMTime {
        CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    }
}
