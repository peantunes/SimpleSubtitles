# Simple Subtitles

Supports *tvOS*, *iOS* is  in development. 
If you are looking to use custom WebVTT subtitles without having to change the HLS header files, this is the solution. I have been looking for something like this and I think more people are looking for the same solution.

## How to use

Because it is still in development for iOS, I am able to test it very well for Apple TV. Just use the code below to run a video
```Swift
import AVKit
import UIKit
import SimpleSubtitles

class MyPlayerViewController: AVPlayerViewController {
    var subtitlesController: SubtitlesController?
    override func viewDidLoad() {
        let player = AVPlayer(url: URL(string: <<Your video URL>>)!)
        self.player = player
        subtitlesController = SimpleSubtitles.make(player: player, view: view)
        subtitlesController?.setLanguage(url: <<Your WebVTT URL>>)
        
        player.play()
    }
}
```
