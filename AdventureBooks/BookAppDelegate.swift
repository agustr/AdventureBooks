import AVFoundation
import UIKit

let BUNDELEDSTORIESFOLDER = "BundeledStories"
let USERSTORIESFOLDER = "userstories"

@UIApplicationMain
class BookAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var libraries: [Library] = []

    lazy var bundledStoriesURL: URL? = {
        Bundle.main.url(forResource: BUNDELEDSTORIESFOLDER, withExtension: nil)
    }()

    lazy var userStoriesURL: URL? = {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return documentsURL?.appendingPathComponent(USERSTORIESFOLDER, isDirectory: true)
    }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UserDefaults.standard.register(defaults: ["showText": true])
        UserDefaults.standard.register(defaults: ["autoPageTurning": true])
        UserDefaults.standard.register(defaults: ["playAudio": true])

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print("could not set audio category option due to: \(error)")
        }
        createLibraries()
        let window = UIWindow(frame: UIScreen.main.bounds)
        let libraryVC = LibraryViewController()
        let rootVC = UINavigationController(rootViewController: libraryVC)
        rootVC.setNavigationBarHidden(true, animated: false)
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

    func createLibraries() {
        if let bundledStoriesUrl = self.bundledStoriesURL {
            let bundledLibrary = Library(WithFolder: bundledStoriesUrl, AndTitle: "Ævintýri")
            libraries.append(bundledLibrary)
        }

        if let userStoriesUrl = self.userStoriesURL {
            let userLibrary = Library(WithFolder: userStoriesUrl, AndTitle: "Mínar Sögur")
            libraries.append(userLibrary)
        }
    }
}
