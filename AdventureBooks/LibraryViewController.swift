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
        libraryView.tableView.delegate = self
        libraryView.tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.reuseIdentifer)
        
        libraryView.settingsButton.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        self.view = libraryView
    }
    
    @objc func settingsButtonPressed() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .popover
        
        present(settingsVC, animated: true) {
           // stuffy thing
        }
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
        var cell: UITableViewCell
        if let bookCell = libraryView.tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.reuseIdentifer) as? BookTableViewCell {
            bookCell.book = libraries[indexPath.section].books[indexPath.row]
            cell = bookCell
        } else {
            cell = UITableViewCell()
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return libraries.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return libraries[section].title
    }
}

extension LibraryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = libraries[indexPath.section].books[indexPath.row]
        let bookViewController = BookViewController(book: book)
        self.navigationController?.pushViewController(bookViewController, animated: true)
    }
}
