import Foundation
import SubtitlesInterface

class WebVTTParser: SubtitlesParserProtocol {
    private static let regexPattern = #"(?m)^((\d{1,2}:)?\d{2}:\d{2}\.\d+) +--> +((\d{1,2}:)?\d{2}:\d{2}\.\d+).*[\r\n]+\s*(?s)((?:(?!\r?\n\r?\n).)*)"#
    private static let regexPattern2 = #"([0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]+)"#
    
    func parse(string: String) -> SubtitleInformation? {
        guard let regex1 = try? NSRegularExpression(pattern: WebVTTParser.regexPattern, options: []) else {
            return nil
        }
        var sections: [SubtitleInformation.Section] = []
        
        let nsrange = NSRange(string.startIndex..<string.endIndex,
                              in: string)
        
        regex1.enumerateMatches(in: string, options: .reportCompletion, range: nsrange) { (match, flags, any) in
            guard let match = match else { return }
            if match.numberOfRanges >= 3,
               let timeStartRange = Range(match.range(at: 1),
                                     in: string),
               let timeEndRange = Range(match.range(at: 3),
                                   in: string),
               let linesRange = Range(match.range(at: 5),
                                  in: string) {
                let timeStart = string[timeStartRange].convertToTimeInterval()
                let timeEnd = string[timeEndRange].convertToTimeInterval()
                let lines = String(string[linesRange])
                sections.append(.init(startTime: timeStart, endTime: timeEnd, lines: lines))
            }
        }
        
        return SubtitleInformation(sections: sections)
    }
}

private extension StringProtocol {
    func NSRange(of substring: String) -> NSRange? {
        guard let range = range(of: substring) else { return nil }

        let start = distance(from: startIndex, to: range.lowerBound) as Int
        let end = distance(from: startIndex, to: range.upperBound) as Int
        return NSMakeRange(start, end - start)
    }
    
    func convertToTimeInterval() -> TimeInterval {
        guard self != "" else {
            return 0
        }

        var interval:Double = 0

        let parts = self.components(separatedBy: ":")
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }

        return interval
    }
}

