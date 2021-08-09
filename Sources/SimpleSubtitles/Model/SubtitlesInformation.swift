import AVFoundation

public struct SubtitleInformation: Equatable {
    public struct Section: Equatable {
        public let startTime: TimeInterval
        public let endTime: TimeInterval
        
        public let lines: String
        
        public init(startTime: TimeInterval, endTime: TimeInterval, lines: String) {
            self.startTime = startTime
            self.endTime = endTime
            self.lines = lines
        }
    }
    
    public let sections: [Section]
    
    public init(sections: [SubtitleInformation.Section]) {
        self.sections = sections
    }
}
