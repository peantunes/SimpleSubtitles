# Simple Subtitles

Supports *tvOS* (*iOS* is  in development). 
If you are looking to use custom WebVTT subtitles without having to change the HLS header files, this is the solution. I have been looking for something like this and I think more people are looking for the same solution.

## How to use

Because it is still in development for iOS, I am able to test it very well for Apple TV.

[Top menu with the Subtitles menu](Documentation/images/top_menu.jpg)

If you want to add support to the AppleTV menu use the sample below:

```Swift
import AVKit
import UIKit
import SimpleSubtitles

class MyPlayerViewController: AVPlayerViewController {
    var subtitlesController: SubtitlesController?
    override func viewDidLoad() {
        let player = AVPlayer(url: URL(string: <<Your video URL>>)!)
        self.player = player
        let languages: [SubtitleLanguage] = [
            .init(id: "1", label: "English", url: "<< your English vtt >>"),
            .init(id: "2", label: "Português (Brasil)", url: "<< your Portuguese vtt >>")
          ]
        subtitlesController = SimpleSubtitles.make(player: player, viewController: self,
                                                   options: .init(timeAdjustForContent: 0.0,
                                                                  languagesAvailable: languages,
                                                                  defaultLanguage: languages.first
                                                   )
        )
        
        player.play()
    }
}
```

In case to only use the player with the information you have only to set the Language (VTT file) you want to use.

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

If you need to change subtitles later, just call the `setLanguage(url: String)` and it will load and continue from that point.

## Next steps

* support for iOS
* support showing subtitles menu on the tvOS standard player
