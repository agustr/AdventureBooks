import AVFoundation
import UIKit

@UIApplicationMain
class BookAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

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
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = LibraryViewController()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
