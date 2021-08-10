import CoreMedia

public protocol SubtitlesControlViewProtocol: AnyObject {
    func perform(update: SubtitlesControl.Update)
}

public enum SubtitlesControl {
    public enum Update: Equatable {
        case showSubtitles(ViewModel)
        case hideSubtitles
    }
    
    public struct ViewModel: Equatable {
        public let lines: String
        
        public init(lines: String) {
            self.lines = lines
        }
    }
}

public protocol PlayerControlProtocol: AnyObject {
    func addPeriodicTimeObserver(forInterval interval: CMTime, queue: DispatchQueue?, using block: @escaping (CMTime) -> Void) -> Any
    func removeTimeObserver(_ observer: Any)
}
