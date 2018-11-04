import Cocoa
import Zip
import UserNotifications


class DropView: NSView {
    var plugin = LocalPlugin.self
    var success : [String] = []
    var fail : [String] = []
    var failReason : [String] = []
    var filePath: [String]?
    let expectedExt = ["zip"]
    let expectedExtForImage = ["jpg","png"]
    let nCenter = NSUserNotificationCenter.default

    @objc var isDir : ObjCBool = false
    
    required init?(coder: NSCoder) {super.init(coder: coder)}
    
    func importNotification(notification: NSNotification){
        
    }
    
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
        
        /*if #available(OSX 10.14, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge], completionHandler: {allowed, error in
                
                if allowed {
                    print("Authorization is \(allowed)")
                }
            })
        } else {*/
            nCenter.delegate = self
        
        //}
    }
    
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard let board = sender.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray else {
                return NSDragOperation()
        }
        
        for path in board {
            if let pathName = path as? String {
                if checkFileExtention(pathName) {
                    self.layer?.backgroundColor = NSColor.blue.cgColor
                    print("Check Pass")
                    return .copy
                }else{
                    self.layer?.backgroundColor = NSColor.red.cgColor
                    print("Check Fail")
                    return NSDragOperation()
                }
            }else{
                return NSDragOperation()
            }
        }
        
        return NSDragOperation()
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor.gray.cgColor
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        self.layer?.backgroundColor = NSColor.gray.cgColor
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray
            else { return false }
        
        
        
        
        //GET YOUR FILE PATH !!!
        for path in pasteboard {
            if let pathName = path as? String {
                self.filePath?.append(pathName)
                let sourceComponent = URL(fileURLWithPath: pathName).pathComponents
                
                let sourceFolderName = sourceComponent[sourceComponent.count - 1]
                let bookTitle = sourceFolderName
                
                var desURL : URL = LocalPlugin.getApplicationSupportAppDirectory()!
                desURL.appendPathComponent("Books/\(sourceFolderName)/\(sourceFolderName)")
                let destinationPath : String = desURL.path
                
                let type = fileTyp(pathName)
                switch type {
                case "folder":
                    createFolderForManga(sourcePath: pathName, destinationPath: destinationPath, bookName: bookTitle)
                    break
                case "zip":
                    extractZip(atPath: pathName, toPath: destinationPath, bookName: bookTitle)
                    break
                default:
                    break
                }
            }
        }
        
       /* if #available(OSX 10.14, *) {
            let context = UNMutableNotificationContent()
            context.title = "EdgeViewer Local File Import Result"
            context.body = ""
            if (success.count > 0){
                
                context.body += "Success: \n"
                for successFile in success {
                    context.body += successFile
                    context.body += "\n"
                }
            }
            if (fail.count > 0){
                context.body += "Fail: \n"
                for failure in fail {
                    let failItem = failure + "\n"
                    context.body += failItem
                
                }
            }
            
            context.sound = UNNotificationSound.default()
            context.badge = 1
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let notification = UNNotificationRequest(identifier: "import", content: context, trigger: trigger)
            
            UNUserNotificationCenter.current().add(notification, withCompletionHandler: nil)
            fail = []
            success = []
        } else {*/
            
            let context = NSUserNotification();
            context.title = "EdgeViewer Local File Import Result"
            context.informativeText = ""
            
            if (success.count > 0){
                
                context.informativeText! += "Success: \n"
                for successFile in success {
                    context.informativeText! += successFile
                    context.informativeText! += "\n"
                }
            }
            if (fail.count > 0){
                context.informativeText! += "Fail: \n"
                for failure in fail {
                    let failItem = failure + "\n"
                    context.informativeText! += failItem
                }
            }
            context.identifier = "Import"
            context.soundName = NSUserNotificationDefaultSoundName
            context.deliveryDate = Date.init(timeInterval: 10, since: Date.init())
        
        
            let viewDetail = NSUserNotificationAction(identifier: "Detail", title: "Detail")
            context.additionalActions?.append(viewDetail)
        
            print(context)
        
            nCenter.scheduleNotification(context)
            nCenter.deliver(context)
        
            print(nCenter.deliveredNotifications)
            print(nCenter.scheduledNotifications)
            
        //}
        
        
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
            createFolderForManga(sourcePath: destinationURL.path, destinationPath: (LocalPlugin.getApplicationSupportAppDirectory()?.path)! + "/Books/\(sourceZipName)/\(sourceZipName)", bookName:  String(sourceZipName))
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
        
            let newBook : Book = Book(owner: LocalPlugin.sharedInstance , identifier: (bookName,bookName), type: BookType.manga)
            newBook.title = bookName
            
            newBook.currentPage = 0
            newBook.bookmark = 0
            
            try fileManager.createDirectory(atPath: destinationPath, withIntermediateDirectories: true, attributes: nil)
            
            try fileManager.createDirectory(atPath: destinationPath + "/Images", withIntermediateDirectories: true, attributes: nil)
            
            for file in files {
                let suffix = URL(fileURLWithPath: (sourcePath + "/" + file)).pathExtension
                for ext in expectedExtForImage {
                    if ext.lowercased() == suffix {
                        let fileName = String(count) + "." + suffix
                        try fileManager.copyItem(atPath: (sourcePath + "/" + file), toPath: (destinationPath + "/Images/" + fileName))
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
            success.append(bookName)
        }catch{
            fail.append(bookName)
            failReason.append(error.localizedDescription)
            print("Error: \(error.localizedDescription)")
        }
        
    }
}

/*@available(OSX 10.14, *)
extension DropView : UNUserNotificationCenterDelegate {
   
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print(response)
        if response.notification.request.identifier == "import" {
            print("imported")
            let notification = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Notification")) as! NSWindowController
            
            let importNotification = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ImportNotification")) as! ImportNotification
            
            notification.showWindow(importNotification)
            
            
            
            
        }
    }
}*/

extension DropView: NSUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification) {
        print(center.deliveredNotifications)
        print(center.scheduledNotifications)
    }
    
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        if notification.identifier == "Import" {
            let iNotification = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Notification")) as! NSWindowController
            
            let importNotification = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ImportNotification")) as! ImportNotification
            
            iNotification.showWindow(importNotification)
        }
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
}


