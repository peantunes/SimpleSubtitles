import CoreMedia
import SimpleSubtitles

class PlayerControlMock: PlayerControlProtocol {
    enum Event: Equatable {
        case addPeriodicTimeObserver
        case removeTimeObserver
    }
    var logs: [Event] = []
    
    var block: ((CMTime) -> Void)? = nil
    
    func addPeriodicTimeObserver(forInterval interval: CMTime, queue: DispatchQueue?, using block: @escaping (CMTime) -> Void) -> Any {
        self.block = block
        logs.append(.addPeriodicTimeObserver)
        return 1
    }
    
    func removeTimeObserver(_ observer: Any) {
        logs.append(.removeTimeObserver)
        block = nil
    }
    
    func mockBlock(time: CMTime) {
        block?(time)
    }
}
