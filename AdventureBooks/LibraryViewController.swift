import UIKit

class LibraryViewController: UIViewController {
    var libraries: [Library] = {
        var libraries: [Library] = []
        if let bookAppDelegate = UIApplication.shared.delegate as? BookAppDelegate {
            libraries = bookAppDelegate.libraries
        }
        return libraries
    }()
    
    var libraryView: LibraryView! {
        return self.view as? LibraryView
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let libraryView = LibraryView(frame: UIScreen.main.bounds)
        libraryView.tableView.dataSource = self
        self.view = libraryView
    }
}

extension LibraryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if section + 1 <= libraries.count {
            let library = libraries[section]
            numberOfRows = library.books.count
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = libraryView.tableView.dequeueReusableCell(withIdentifier: "bookCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "bookCell")
        }
        cell!.textLabel!.text = "Hello World"
        return cell!
    }
}
