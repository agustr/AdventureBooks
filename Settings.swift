import Foundation

class Settings {
    struct SettingsBundleKeys {
        static let showText = "show_text"
        static let automaticPageTurning = "automatic_page_turning"
        static let automaticallyPlayAudio = "play_audio"
    }
    
    var showText: Bool {
        get {
            UserDefaults.standard.bool(forKey: SettingsBundleKeys.showText)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: SettingsBundleKeys.showText)
        }
    }
    
    var automaticPageTurning: Bool {
        get {
            UserDefaults.standard.bool(forKey: SettingsBundleKeys.automaticPageTurning)
        }
        set {
            if newValue == true {
                UserDefaults.standard.setValue(newValue, forKey: SettingsBundleKeys.automaticallyPlayAudio)
            }
            UserDefaults.standard.setValue(newValue, forKey: SettingsBundleKeys.automaticPageTurning)
        }
    }
    
    var automaticallyPlayAudio: Bool {
        get {
            UserDefaults.standard.bool(forKey: SettingsBundleKeys.automaticallyPlayAudio)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: SettingsBundleKeys.automaticallyPlayAudio)
        }
    }
}
