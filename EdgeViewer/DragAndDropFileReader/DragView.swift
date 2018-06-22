import Cocoa
import Foundation
import Compression

class DropView: NSView {
    
    var filePath: String?
    let expectedExt = ["zip"]  //file extensions allowed for Drag&Drop (example: "jpg","png","docx", etc..)
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
        print("File Entered")
        guard let board = sender.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = board[0] as? String else {
                return NSDragOperation()
        }
        if checkFileExtention(path) {
            print("File pass test")
            self.layer?.backgroundColor = NSColor.blue.cgColor
            return .copy
        }else{
            print("not pass")
            self.layer?.backgroundColor = NSColor.red.cgColor
            return NSDragOperation()
        }
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        print("file exit")
        self.layer?.backgroundColor = NSColor.gray.cgColor
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        print("file end")
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
        
        var desURL : URL = self.getApplicationSupportAppDirectory()!
        desURL.appendPathComponent("Books/unKnowAuthor/\(sourceFolderName)")
        let destinationPath : String = desURL.path
        
        var type = fileTyp(path)
        switch type {
        case "folder":
            print("is folder")
            createFolderForManga(sourcePath: path, destinationPath: destinationPath)
            break
        case "zip":
            print("is zip")
            extractZip(atPath: path, toPath: path)
            break
        default:
            print("not recognized")
            break
        }
        
        
        return true
    }
    
    fileprivate func checkFileExtention(_ drag : String) -> Bool{
        print("Start Checking")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: drag, isDirectory:&isDir) {
            if isDir.boolValue {
                return true
            }
        }
        let suffix = URL(fileURLWithPath: drag).pathExtension
        print("IS" + suffix)
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
    
    fileprivate func getApplicationSupportAppDirectory() -> URL? {
        let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        if paths.count >= 1 {
            return NSURL(fileURLWithPath: paths[0], isDirectory: true).appendingPathComponent("EdgeViewer")
        }
        print("Could not find application support directory.")
        return nil
    }
    
    
    fileprivate func extractZip(atPath : String, toPath : String){
        let fileManager = FileManager()
        let sourceURL : URL = URL(fileURLWithPath: atPath)
        let sourceZip : String = sourceURL.pathComponents[sourceURL.pathComponents.count - 1]
        
        let sourceZipName = sourceZip.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)[0]
        
        var destinationURL = URL(fileURLWithPath: NSTemporaryDirectory() as String)
        destinationURL.appendPathComponent(String(sourceZipName))
        
        if let data = NSData(contentsOfFile: atPath) {
            let bytes = data.bytes.assumingMemoryBound(to: UInt8.self)
            
            let sourceBuffer: UnsafePointer<UInt8> = UnsafePointer<UInt8>(bytes)
            let sourceBufferSize: Int = data.length
            
            let destinationBuffer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: sourceBufferSize)
            let destinationBufferSize: Int = sourceBufferSize
            
            if compression_decode_buffer(destinationBuffer, destinationBufferSize, sourceBuffer, sourceBufferSize, nil, COMPRESSION_LZFSE) == 1{
                let resultData = NSData(bytes: destinationBuffer, length: destinationBufferSize)
                print(resultData)
            }
            
            do {
                try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
                
            } catch {
                print("Extraction of ZIP archive failed with error:\(error)")
            }
        }
        
    }
    
    fileprivate func createFolderForManga(sourcePath : String, destinationPath : String ) {
        let fileManager = FileManager.default
        var count = 0
        do {
            let files = try fileManager.contentsOfDirectory(atPath: sourcePath)
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
        }catch{
            print("Error: \(error.localizedDescription)")
        }
        
    }
}
