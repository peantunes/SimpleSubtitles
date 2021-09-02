import AVKit
import UIKit
import AVFoundation
import SubtitlesInterface

class FileLoaderDefault: FileLoader {
    func loadStringFile(url: String) throws -> String? {
        guard let finalUrl = URL(string: url) else {
            return nil
        }
        let data = try Data(contentsOf: finalUrl)
        return String(data: data, encoding: .utf8)
    }
}

public struct SimpleSubtitlesOptions {
    let timeAdjustForContent: Double
    let languagesAvailable: [SubtitleLanguage]
    public init(timeAdjustForContent: Double = 0,
                languagesAvailable: [SubtitleLanguage] = []) {
        self.timeAdjustForContent = timeAdjustForContent
        self.languagesAvailable = languagesAvailable
    }
}

public struct SimpleSubtitles {
    public static func make(player: AVPlayer, view: UIView, options: SimpleSubtitlesOptions = SimpleSubtitlesOptions()) -> SubtitlesController {
        let interactor = SubtitlesInteractor(parser: WebVTTParser(), fileLoader: FileLoaderDefault(), options: options)
        let presenter = SubtitlesControlPresenter(player: player, interactor: interactor)
        let subtitleView = SubtitlesTextView(presenter: presenter)
        presenter.view = subtitleView
        view.addSubview(subtitleView)
        subtitleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleView.topAnchor.constraint(equalTo: view.topAnchor),
            subtitleView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            subtitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subtitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        return presenter
    }
    
    public static func make(player: AVPlayer, viewController: AVPlayerViewController, options: SimpleSubtitlesOptions = SimpleSubtitlesOptions()) -> SubtitlesController {
        let interactor = SubtitlesInteractor(parser: WebVTTParser(), fileLoader: FileLoaderDefault(), options: options)
        let presenter = SubtitlesControlPresenter(player: player, interactor: interactor)
        let subtitleView = SubtitlesTextView(presenter: presenter)
        presenter.view = subtitleView
        if let view = viewController.view {
            view.addSubview(subtitleView)
            subtitleView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                subtitleView.topAnchor.constraint(equalTo: view.topAnchor),
                subtitleView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                subtitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                subtitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
        if !options.languagesAvailable.isEmpty {
            let subtitleSelection = SubtitleSelectionViewController(interactor: interactor, languages: options.languagesAvailable)
            subtitleSelection.title = NSLocalizedString("subtitles_title", bundle: .module, comment: "Subtitles title for the menu on tvOS")
            
            #if os(tvOS)
            viewController.customInfoViewController = subtitleSelection
            #endif
        }
        return presenter
    }
}

extension AVPlayer: PlayerControlProtocol { }
