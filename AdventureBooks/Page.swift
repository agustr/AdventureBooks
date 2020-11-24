import AVFoundation
import Foundation

@objc class Page: NSObject {
    @objc var imageURL: URL?
    @objc var audioURL: URL? {
        didSet {
            if let audioURL = audioURL {
                do {
                    if #available(iOS 10.0, *) {
                        audioPlayer?.setVolume(0, fadeDuration: 0.4)
                    } else {
                        // Fallback on earlier versions
                    }
                    audioPlayer?.stop()
                    try audioPlayer = AVAudioPlayer(contentsOf: audioURL as URL)
                    audioPlayer?.delegate = self
                } catch {
                    print("could not initialize audioplayer: \(error)")
                }
            } else {
                audioPlayer = nil
            }
        }
    }
    
    @objc var textURL: URL?
    var audioPlayer: AVAudioPlayer?
    unowned let book: Book
    
    init(image: URL?, audio: URL?, text: URL?, book: Book) {
        self.book = book
        self.imageURL = image
        self.audioURL = audio
        self.textURL = text
        super.init()
    }
    
    func play() {
        audioPlayer?.play()
    }
    
    func pause() {
        audioPlayer?.pause()
    }
}

extension Page: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {}

    /* if an error occurs while decoding it will be reported to the delegate. */
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        //
    }
}
