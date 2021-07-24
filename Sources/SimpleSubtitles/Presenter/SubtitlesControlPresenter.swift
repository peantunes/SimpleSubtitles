import CoreMedia

class SubtitlesControlPresenter: SubtitlesController {
    private let interactor: SubtitlesInteractorProtocol
    private weak var player: PlayerControlProtocol?
    private var timeObserver:Any? = nil
    
    weak var view: SubtitlesControlViewProtocol?
    private var previousSection: SubtitleInformation.Section?
    private var isOn: Bool = true
    
    init(player: PlayerControlProtocol, interactor: SubtitlesInteractorProtocol) {
        self.player = player
        self.interactor = interactor
        initialiserObserver()
    }
    
    deinit {
        if let timeObserver = self.timeObserver {
            self.player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
    }
    
    func setLanguage(url: String) {
        interactor.setSubtitleFile(url: url)
        isOn = true
    }
    
    func turnOff() {
        isOn = false
        view?.perform(update: .hideSubtitles)
    }
    
    func timeUpdate(_ time: CMTime) {
        guard isOn else {
            return
        }
        
        guard let section = interactor.sectionFromTime(time.seconds) else {
            view?.perform(update: .hideSubtitles)
            return
        }
        if section != previousSection {
            view?.perform(update: .showSubtitles(SubtitlesControl.ViewModel(section)))
        }
    }
    
    // MARK: - private methods
    
    private func initialiserObserver() {
        let interval = CMTimeMakeWithSeconds(0.01, preferredTimescale: Int32(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: timeUpdate)
    }
}

extension SubtitlesControl.ViewModel {
    init(_ section: SubtitleInformation.Section) {
        self.init(lines: section.lines)
    }
}
