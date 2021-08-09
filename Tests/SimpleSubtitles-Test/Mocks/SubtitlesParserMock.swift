import Foundation
import SimpleSubtitles

class SubtitlesParserMock: SubtitlesParserProtocol {
    enum Event: Equatable {
        case parse(string: String)
    }
    
    var log: [Event] = []
    
    var stubResponseInformation: SubtitleInformation? = .init(sections: [.init(startTime: 0, endTime: 10, lines: "My first line")])
    
    func parse(string: String) -> SubtitleInformation? {
        log.append(.parse(string: string))
        return stubResponseInformation
    }
}
