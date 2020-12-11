import UIKit

class PageViewController: UIViewController {
    let page: Page
    
    var pageView: PageView? {
        if let pageView = self.view as? PageView {
            return pageView
        } else {
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    init(with page: Page) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = PageView(frame: CGRect.zero, andPage: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let bookAppDelegate = UIApplication.shared.delegate as? BookAppDelegate {
            let showText = bookAppDelegate.settings.showText
            pageView?.setTextHidden(hidden: !showText, Animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.pageView?.play()
    }
}
