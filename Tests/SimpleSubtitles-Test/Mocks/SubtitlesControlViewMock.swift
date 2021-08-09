import SimpleSubtitles

class SubtitlesControlViewMock: SubtitlesControlViewProtocol {
    var logs: [SubtitlesControl.Update] = []
    
    func perform(update: SubtitlesControl.Update) {
        logs.append(update)
    }
}
