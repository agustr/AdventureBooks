import Foundation

class Book {
    var pages: [Page] = []
    var icon: URL?
    let sourceFolder: URL
    let title: String
    
    init?(sourceFolder: URL) {
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: sourceFolder.path,
                                          isDirectory: &isDirectory) && isDirectory.boolValue {
            self.sourceFolder = sourceFolder
            self.title = sourceFolder.lastPathComponent
            self.icon = self.getFilesWithPredicate(predicate: "icon").first
            self.pages = self.createPages()
        } else {
            return nil
        }
    }
    
    func createPages() -> [Page] {
        let images: [URL] = getFilesWithPredicate(predicate: "image")
        let audios: [URL] = getFilesWithPredicate(predicate: "audio")
        let texts: [URL] = getFilesWithPredicate(predicate: "text")
        let numberOfPages = ([images.count, audios.count, texts.count].max() != nil) ?
            [images.count, audios.count, texts.count].max()! : 0
        
        var tempPages: [Page] = []
        for _ in 0 ..< numberOfPages {
            tempPages.append(Page(image: nil, audio: nil, text: nil, book: self))
        }
        for (index, image) in images.enumerated() {
            tempPages[index].imageURL = image
        }
        for (index, audio) in audios.enumerated() {
            tempPages[index].audioURL = audio
        }
        for (index, text) in texts.enumerated() {
            tempPages[index].textURL = text
        }
        
        return tempPages
    }
    
    func getFilesWithPredicate(predicate: String) -> [URL] {
        var result: [URL] = []
        do {
            let fileManager = FileManager.default
            let folderContents = try fileManager.contentsOfDirectory(at: sourceFolder, includingPropertiesForKeys: nil,
                                                                     options: .skipsHiddenFiles)
            
            result = (folderContents.compactMap { (url) -> URL? in
                url.lastPathComponent.hasPrefix(predicate) ? url : nil
            }).sorted { (first, second) -> Bool in
                first.lastPathComponent < second.lastPathComponent
            }
        } catch {
            print("Unexpected error: \(error).")
        }
        return result
    }
    
    func pageBeforePage(page: Page) -> Page? {
        var previousPage: Page?
        let indexOfPage = self.pages.firstIndex { (inPage) -> Bool in
            inPage === page
        }
        
        if let indexOfPage = indexOfPage, indexOfPage > 0 {
            previousPage = self.pages[indexOfPage - 1]
        }
        return previousPage
    }
    
    func pageAfterPage(page: Page) -> Page? {
        var nextPage: Page?
        let indexOfPage = self.pages.firstIndex { (inPage) -> Bool in
            inPage === page
        }
        
        if let indexOfPage = indexOfPage, indexOfPage < self.pages.endIndex - 1 {
            nextPage = self.pages[indexOfPage + 1]
        }
        return nextPage
    }
}
