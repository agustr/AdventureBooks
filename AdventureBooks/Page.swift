import AVFoundation
import Foundation

class Page {
    var imageURL: URL?
    var audioURL: URL?
    var textURL: URL?
    var text: String? {
        var text: String?
        do {
            if let url = self.textURL {
                text = try String(contentsOf: url, encoding: .utf8)
            }
        } catch {
            print("could not read string file due to: \(error)")
        }
        return text
    }
    var audioPlayer: AVAudioPlayer?
    unowned let book: Book
    
    init(image: URL?, audio: URL?, text: URL?, book: Book) {
        self.book = book
        self.imageURL = image
        self.audioURL = audio
        self.textURL = text
    }
}
