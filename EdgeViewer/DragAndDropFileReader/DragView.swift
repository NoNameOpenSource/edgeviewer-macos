import Cocoa
import Zip

class DropView: NSView {
    var plugin = LocalPlugin.self
    var filePath: String?
    let expectedExt = ["zip"]
    let expectedExtForImage = ["jpg","png"]
    @objc var isDir : ObjCBool = false
    
    required init?(coder: NSCoder) {super.init(coder: coder)}
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.gray.cgColor
        
        
        
        if #available(OSX 10.13, *) {
            registerForDraggedTypes([NSPasteboard.PasteboardType.URL, NSPasteboard.PasteboardType.fileURL])
        } else {
            // Fallback on earlier versions
            registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")])
        }
    }
    
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard let board = sender.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = board[0] as? String else {
                return NSDragOperation()
        }
        if checkFileExtention(path) {
            self.layer?.backgroundColor = NSColor.blue.cgColor
            return .copy
        }else{
            self.layer?.backgroundColor = NSColor.red.cgColor
            return NSDragOperation()
        }
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor.gray.cgColor
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        self.layer?.backgroundColor = NSColor.gray.cgColor
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = pasteboard[0] as? String
            else { return false }
        
        
        
        
        //GET YOUR FILE PATH !!!
        self.filePath = path
        
        let sourceComponent = URL(fileURLWithPath: path).pathComponents
        
        let sourceFolderName = sourceComponent[sourceComponent.count - 1]
        let bookTitle = sourceFolderName
        
        var desURL : URL = LocalPlugin.getApplicationSupportAppDirectory()!
        desURL.appendPathComponent("Books/--Unknown Series--/\(sourceFolderName)")
        let destinationPath : String = desURL.path
        
        var type = fileTyp(path)
        switch type {
        case "folder":
            createFolderForManga(sourcePath: path, destinationPath: destinationPath, bookName: bookTitle)
            break
        case "zip":
            extractZip(atPath: path, toPath: path, bookName: bookTitle)
            break
        default:
            break
        }
        
        
        return true
    }
    
    fileprivate func checkFileExtention(_ drag : String) -> Bool{
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: drag, isDirectory:&isDir) {
            if isDir.boolValue {
                return true
            }
        }
        let suffix = URL(fileURLWithPath: drag).pathExtension
        if suffix == "zip" {
            return true
        }
        
        return false
        
    }
    
    fileprivate func fileTyp(_ filename : String) -> String {
        let suffix = URL(fileURLWithPath: filename).pathExtension
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: filename, isDirectory:&isDir) {
            if isDir.boolValue {
                return "folder"
            }
            
        }
        
        for ext in self.expectedExt {
            if ext.lowercased() == suffix {
                return "zip"
            }
        }
        
        
        return "nil"
    }
    
    
    
    fileprivate func extractZip(atPath : String, toPath : String, bookName : String){
        let fileManager = FileManager()
        let sourceURL : URL = URL(fileURLWithPath: atPath)
        let sourceZip : String = sourceURL.pathComponents[sourceURL.pathComponents.count - 1]
        
        let sourceZipName = sourceZip.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)[0]
        
        
        var destinationURL = URL(fileURLWithPath: NSTemporaryDirectory() as String)
        destinationURL.appendPathComponent(String(sourceZipName))
        
        do {
            try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
            try Zip.unzipFile(URL(fileURLWithPath: atPath), destination: destinationURL, overwrite: true, password: nil)
            createFolderForManga(sourcePath: destinationURL.path, destinationPath: (LocalPlugin.getApplicationSupportAppDirectory()?.path)! + "/Books/--Unknown Series--/\(sourceZipName)", bookName:  bookName)
            try fileManager.removeItem(at: destinationURL)
        } catch {
            print("Extraction of ZIP archive failed with error:\(error)")
        }
        
    }
    
    fileprivate func createFolderForManga(sourcePath : String, destinationPath : String, bookName : String ) {
        let fileManager = FileManager.default
        var count = 0
        do {
            let files = try fileManager.contentsOfDirectory(atPath: sourcePath)
        
            let newBook : Book = Book(owner: LocalPlugin.sharedInstance , identifier: ("--Unknown Series--",bookName), type: BookType.manga)
            newBook.title = bookName
            
            newBook.currentPage = 0
            newBook.bookmark = 0
            
            try fileManager.createDirectory(atPath: destinationPath, withIntermediateDirectories: true, attributes: nil)
            for file in files {
                let suffix = URL(fileURLWithPath: (sourcePath + "/" + file)).pathExtension
                for ext in expectedExtForImage {
                    if ext.lowercased() == suffix {
                        let fileName = String(count) + "." + suffix
                        try fileManager.copyItem(atPath: (sourcePath + "/" + file), toPath: (destinationPath + "/" + fileName))
                        count += 1
                    }
                }
            }
            newBook.numberOfPages = count
            LocalPluginXMLStorer.storeBookData(ofBook: newBook)
            guard let _ = NSImage(contentsOf: URL(fileURLWithPath: sourcePath + "/" + files[0], isDirectory: false)) else {
                return
            }
            newBook.coverImage =  NSImage(contentsOf: URL(fileURLWithPath: sourcePath + "/" + files[0], isDirectory: false))!
        }catch{
            print("Error: \(error.localizedDescription)")
        }
        
    }
}


