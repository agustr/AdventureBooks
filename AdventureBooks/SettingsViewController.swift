import UIKit

class SettingsViewController: UIViewController {

    var settingsView: SettingsView! {
        if let settingsView = self.view as? SettingsView {
            return settingsView
        } else {
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.view = SettingsView(showText: false, playAudio: false, turnPage: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.settingsView.stackView.axis = .vertical
    }
    
}
