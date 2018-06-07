//
//  LocalPlugin.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 4/28/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class LocalPlugin: Plugin {
    var name = "LocalPlugin"
    var version = 0.1
    
    private init(name: String, version: Double) {
        self.name = name
        self.version = version
    }
    static var sharedInstance = LocalPlugin(name: "LocalPlugin", version: 0.1)
    
    func page(withIdentifier identifier: Any) -> LibraryPage? {
        return LibraryPage(identifier: identifier, type: .regular)
    }
    
    func book(withIdentifier identifier: Any) -> Book? {
        let xmlParser = LocalPluginXMLParser(identifier: identifier as! UUID)
        return xmlParser.book
    }
    
    func page(ofBook book: Book, pageNumber: Int) -> NSImage? {
        let bookImageDirectory: URL? = LocalPlugin.getBookDirectory(ofBookWithIdentifier: book.identifier as! UUID)?.appendingPathComponent("Images")
        let fileManager = FileManager.default
        do {
            let filePaths = try fileManager.contentsOfDirectory(at: bookImageDirectory!, includingPropertiesForKeys: nil, options: [])
            for filePath in filePaths {
                if filePath.lastPathComponent.hasPrefix("\(pageNumber).") {
                    return NSImage(contentsOf: filePath)
                }
            }
        }
        catch {
            print("Could not get file paths: \(bookImageDirectory?.absoluteString ?? "the directory could not be found")")
        }
        return nil
    }
    
    func addBook(book: Book) {
        // Get the user's Application Support directory
        let applicationSupportDirectoryURL: URL? = LocalPlugin.getApplicationSupportAppDirectory()
        
        // Create EdgeViewer directory in user's Application Support directory
        do {
            try FileManager.default.createDirectory(at: applicationSupportDirectoryURL!, withIntermediateDirectories: true)
        }
        catch {
            print("Could not create directory: \(error)")
        }
        
        // Store the book data as XML
        LocalPluginXMLStorer.storeBookData(ofBook: book)
    }
    
    static func getApplicationSupportAppDirectory() -> URL? {
        let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        if paths.count >= 1 {
            return NSURL(fileURLWithPath: paths[0], isDirectory: true).appendingPathComponent("EdgeViewer")
        }
        print("Could not find application support directory.")
        return nil
    }
    
    static func getBookDirectory(ofBookWithIdentifier identifier: UUID) -> URL? {
        return LocalPlugin.getApplicationSupportAppDirectory()?.appendingPathComponent("Books/\(identifier.uuidString)")
    }
}
