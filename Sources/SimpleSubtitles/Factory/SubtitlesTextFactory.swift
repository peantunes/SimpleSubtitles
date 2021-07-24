import UIKit
import AVFoundation

class FileLoaderDefault: FileLoader {
    func loadStringFile(url: String) throws -> String? {
        guard let finalUrl = URL(string: url) else {
            return nil
        }
        let data = try Data(contentsOf: finalUrl)
        return String(data: data, encoding: .utf8)
    }
}

public struct SimpleSubtitles {
    public static func make(player: AVPlayer, view: UIView) -> SubtitlesController {
        let interactor = SubtitlesInteractor(parser: WebVTTParser(), fileLoader: FileLoaderDefault())
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
}

extension AVPlayer: PlayerControlProtocol { }
