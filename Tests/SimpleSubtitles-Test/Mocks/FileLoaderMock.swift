import Foundation
import SimpleSubtitles

class FileLoaderMock: FileLoader {
    enum Event: Equatable {
        case loadStringFile(url: String)
    }
    
    var log: [Event] = []
    
    var stubString: String? = "AnyFileContent"
    
    func loadStringFile(url: String) throws -> String? {
        log.append(.loadStringFile(url: url))
        return stubString
    }
}
