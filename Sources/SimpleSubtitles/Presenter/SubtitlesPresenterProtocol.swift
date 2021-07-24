import CoreMedia

public protocol SubtitlesController: AnyObject {
    func setLanguage(url: String)
    func turnOff()
}

protocol SubtitlesControlViewProtocol: AnyObject {
    func perform(update: SubtitlesControl.Update)
}

enum SubtitlesControl {
    enum Update {
        case showSubtitles(ViewModel)
        case hideSubtitles
    }
    
    struct ViewModel: Equatable {
        let lines: String
    }
}

protocol PlayerControlProtocol: AnyObject {
    func addPeriodicTimeObserver(forInterval interval: CMTime, queue: DispatchQueue?, using block: @escaping (CMTime) -> Void) -> Any
    func removeTimeObserver(_ observer: Any)
}
