import Foundation
import SimpleSubtitles

class SubtitlesInteractorMock: SubtitlesInteractorProtocol {
    
    enum Event: Equatable {
        case setSubtitleFile(url: String)
        case sectionsFromTime(Double)
    }
    var logs: [Event] = []
    
    var stubSection: SubtitleInformation.Section? = nil
    var stubSections: [SubtitleInformation.Section] = []
    
    func setSubtitleFile(url: String) {
        logs.append(.setSubtitleFile(url: url))
    }
    
    func sectionsFromTime(_ time: Double) -> [SubtitleInformation.Section] {
        logs.append(.sectionsFromTime(time))
        return stubSections
    }
}
