import Foundation
import SimpleSubtitles

class SubtitlesInteractorMock: SubtitlesInteractorProtocol {
    enum Event: Equatable {
        case setSubtitleFile(url: String)
        case sectionFromTime(Double)
    }
    var logs: [Event] = []
    
    var stubSection: SubtitleInformation.Section? = nil
    
    func setSubtitleFile(url: String) {
        logs.append(.setSubtitleFile(url: url))
    }
    
    func sectionFromTime(_ time: Double) -> SubtitleInformation.Section? {
        logs.append(.sectionFromTime(time))
        return stubSection
    }
}
