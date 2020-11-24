import Foundation

@objc class Book: NSObject {
    @objc var pages: [Page] = []
    @objc var icon: URL?
    @objc let sourceFolder: URL
    @objc let title: String
    
    @objc init?(sourceFolder: URL) {
        var isDirectory:ObjCBool = false
        if FileManager.default.fileExists(atPath: sourceFolder.path, isDirectory: &isDirectory) && isDirectory.boolValue {
            self.sourceFolder = sourceFolder
            self.title = sourceFolder.lastPathComponent
            super.init()
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
        let numberOfPages = ([images.count, audios.count, texts.count].max() != nil) ? [images.count, audios.count, texts.count].max()! : 0
        
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
            let folderContents = try FileManager.default.contentsOfDirectory(at: sourceFolder, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            
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
}
