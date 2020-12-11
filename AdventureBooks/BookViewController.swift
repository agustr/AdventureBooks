import UIKit

class BookViewController: UIPageViewController {
    let book: Book
    
    init(book: Book) {
        self.book = book
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([initialPage()],
                                direction: .forward,
                                animated: false) { pageturnfinished in
            print("pageturn finished \(pageturnfinished)")
        }
        self.dataSource = self
    }
    
    func initialPage() -> UIViewController {
        if let page = self.book.pages.first {
            return PageViewController(with: page)
        } else {
            let viewController = UIViewController()
            viewController.view.backgroundColor = UIColor.red
            return viewController
        }
    }
}

extension BookViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let pageViewController = viewController as? PageViewController,
           let previousPage = self.book.pageBeforePage(page: pageViewController.page) {
            
            return PageViewController(with: previousPage)
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let pageViewController = viewController as? PageViewController,
           let nextPage = self.book.pageAfterPage(page: pageViewController.page) {
            
            return PageViewController(with: nextPage)
        }
        return nil
    }
}
