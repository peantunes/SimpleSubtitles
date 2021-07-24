protocol SubtitlesInteractorProtocol: AnyObject {
    func setSubtitleFile(url: String)
    func sectionFromTime(_ time: Double) -> SubtitleInformation.Section?
}

protocol SubtitlesParserProtocol: AnyObject {
    func parse(string: String) -> SubtitleInformation?
}
