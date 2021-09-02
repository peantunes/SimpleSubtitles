public protocol SubtitlesInteractorProtocol: AnyObject {
    func setSubtitleFile(url: String)
    func removeSubtitles()
    func sectionsFromTime(_ time: Double) -> [SubtitleInformation.Section]
}

public protocol SubtitlesParserProtocol: AnyObject {
    func parse(string: String) -> SubtitleInformation?
}
