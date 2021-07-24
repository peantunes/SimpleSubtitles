import Foundation

protocol FileLoader: AnyObject {
    func loadStringFile(url: String) throws -> String?
}

class SubtitlesInteractor: SubtitlesInteractorProtocol {
    private let parser: SubtitlesParserProtocol
    private let fileLoader: FileLoader
    
    private var subtitleInformation: SubtitleInformation?
    private var previousIndex: Int = 0
    private var previousSection: SubtitleInformation.Section?
    private var previousTime: Double = 0
    
    init(parser: SubtitlesParserProtocol, fileLoader: FileLoader) {
        self.parser = parser
        self.fileLoader = fileLoader
    }
    
    func setSubtitleFile(url: String) {
        guard let text = try? fileLoader.loadStringFile(url: url) else {
            return subtitleInformation = nil
        }
        
        subtitleInformation = parser.parse(string: text)
    }
    
    func sectionFromTime(_ time: Double) -> SubtitleInformation.Section? {
        let currentSeconds = time
        guard var searchSections = subtitleInformation?.sections,
              !(time >= previousSection?.startTime ?? 0 && time < previousSection?.endTime ?? 0) else {
            return previousSection
        }
        
        if currentSeconds > previousTime,
           let nextSection = searchSections[safe: previousIndex + 1],
           nextSection.startTime >= time {
            
        }
        
        if let previousSection = previousSection,
           time >= previousSection.endTime {
            searchSections.removeSubrange(0..<previousIndex)
        } else {
            previousIndex = 0
        }
        guard let sectionIndex = searchSections.firstIndex(where: { time >= $0.startTime && time < $0.endTime }),
              let currentSection = searchSections[safe: sectionIndex] else {
            
            return nil
        }
        previousIndex = previousIndex + sectionIndex
        previousSection = currentSection
        return currentSection
        
    }
}

extension Collection {
    subscript(safe index: Self.Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
