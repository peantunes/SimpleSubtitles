import AVFoundation

struct SubtitleInformation: Equatable {
    struct Section: Equatable {
        let startTime: TimeInterval
        let endTime: TimeInterval
        
        let lines: String
    }
    
    let sections: [Section]
}
