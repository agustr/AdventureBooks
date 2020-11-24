import Foundation

extension Notification.Name {
    static let libraryChanged = Notification.Name("LibraryChanged")
}

class Library: NSObject {
    private var libraryURLs: [URL] = []
    @objc var title: String = ""
    @objc var books: [Book] = []

    @objc init(WithFolder folder: URL, AndTitle title: String) {
        self.title = title
        self.libraryURLs.append(folder)
        super.init()
        self.books = loadBooksFrom(url: folder)
    }

    private func loadBooksFrom(urls: [URL]) -> [Book] {
        var books: [Book] = []
        for url in urls {
            books.append(contentsOf: loadBooksFrom(url: url))
        }
        return books
    }

    private func loadBooksFrom(url: URL) -> [Book] {
        var books: [Book] = []
        do {
            let bookFolders = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for url in bookFolders {
                if let book = Book(sourceFolder: url) {
                    books.append(book)
                }
            }
        } catch {
            print("could not load directory contents because of: \(error)")
        }
        return books
    }

    @objc func reloadLibrary() {
        self.books = loadBooksFrom(urls: self.libraryURLs)
        NotificationCenter.default.post(name: Notification.Name.libraryChanged, object: self)
    }
}
