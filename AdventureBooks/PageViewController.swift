import UIKit

class PageViewController: UIViewController {
    let page: Page

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
}
