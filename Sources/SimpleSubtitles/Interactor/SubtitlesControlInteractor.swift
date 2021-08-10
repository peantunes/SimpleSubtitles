import Foundation
import SubtitlesInterface

public protocol FileLoader: AnyObject {
    func loadStringFile(url: String) throws -> String?
}

class SubtitlesInteractor: SubtitlesInteractorProtocol {
    private let parser: SubtitlesParserProtocol
    private let fileLoader: FileLoader
    private let options: SimpleSubtitlesOptions
    
    private var subtitleInformation: SubtitleInformation?
    private var previousIndex: Int = 0
    private var previousSection: SubtitleInformation.Section?
    private var previousTime: Double = 0
    
    private var listActiveSections: [SubtitleInformation.Section] = []
    
    init(parser: SubtitlesParserProtocol, fileLoader: FileLoader, options: SimpleSubtitlesOptions) {
        self.parser = parser
        self.fileLoader = fileLoader
        self.options = options
    }
    
    func setSubtitleFile(url: String) {
        guard let text = try? fileLoader.loadStringFile(url: url) else {
            return subtitleInformation = nil
        }
        
        subtitleInformation = parser.parse(string: text)
    }
    
    //This was changed to use the other method, but I will keep the logic
    func sectionFromTime(_ time: Double) -> SubtitleInformation.Section? {
        let currentSeconds = time + options.timeAdjustForContent
        guard var searchSections = subtitleInformation?.sections,
              !(currentSeconds >= previousSection?.startTime ?? 0 && currentSeconds < previousSection?.endTime ?? 0) else {
//            print("Previous section", currentSeconds, previousSection)
            return previousSection
        }
        
        if currentSeconds > previousTime,
           let nextSection = searchSections[safe: previousIndex + 1],
           nextSection.startTime >= currentSeconds {
            
        }
        
        if let previousSection = previousSection,
           currentSeconds >= previousSection.endTime {
            searchSections.removeSubrange(0..<previousIndex)
        } else {
            previousIndex = 0
        }
        guard let sectionIndex = searchSections.firstIndex(where: { currentSeconds >= $0.startTime && currentSeconds < $0.endTime }),
              let currentSection = searchSections[safe: sectionIndex] else {
            
            return nil
        }
        previousIndex = previousIndex + sectionIndex
        previousSection = currentSection
        return currentSection
        
    }
    
    func sectionsFromTime(_ time: Double) -> [SubtitleInformation.Section] {
        let currentSeconds = time + options.timeAdjustForContent
        
        let searchSections = subtitleInformation?.sections ?? []
        
        return searchSections.filter( { currentSeconds >= $0.startTime && currentSeconds < $0.endTime } )
    }
}

extension Collection {
    subscript(safe index: Self.Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
