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
    
    func page(withIdentifier identifier: LocalPluginLibraryPageType) -> LibraryPage? {
        print("here here here dude")
        let page = LibraryPage(owner: self, identifier: identifier, type: .regular)
        switch identifier {
            case .homepage:
                let booksDirectory = LocalPlugin.getApplicationSupportAppDirectory()?.appendingPathComponent("Books")
                let fileManager = FileManager.default
                if let booksDirectoryString = booksDirectory?.absoluteString.removingPercentEncoding {
                    print("BooksDirectoryString: \(booksDirectoryString)")
                    do {
                        let authorFolders = try fileManager.contentsOfDirectory(at: booksDirectory!, includingPropertiesForKeys: nil, options: [])
                        print("Book Folder Contents: ")
                        for (authorFolder) in authorFolders {
                            if !authorFolder.absoluteString.hasSuffix(".DS_Store") {
                                do {
                                    let bookFolders = try fileManager.contentsOfDirectory(at: authorFolder, includingPropertiesForKeys: nil, options: [])
                                    for bookFolder in bookFolders {
                                        page.items.append(PageItem(identifier: (authorFolder.lastPathComponent, bookFolder.lastPathComponent), type: .book))
                                    }
                                }
                                catch {
                                    print("cannot get author folders")
                                    return nil
                                }
                            }
                        }
                        print(authorFolders)
                    }
                    catch {
                        print("could not get contents of \(booksDirectory?.absoluteString ?? "")")
                        return nil
                    }
                }
            default:
                print("unhandled LibraryPageType: \(identifier)")
                break
        }
        return page
    }
    
    func page(withIdentifier identifier: Any) -> LibraryPage? {
        return nil
    }
    
    func book(withIdentifier identifier: Any) -> Book? {
        let xmlParser = LocalPluginXMLParser(identifier: identifier as! (String, String))
        xmlParser.book.identifier = (xmlParser.book.author, xmlParser.book.title)
        return xmlParser.book
    }
    
    func page(ofBook book: Book, pageNumber: Int) -> NSImage? {
        guard let bookID = book.identifier as? (String, String) else {
            print("identifier is incorrect type")
            return nil
        }

        let bookImageDirectory: URL? = LocalPlugin.getBookDirectory(ofBookWithIdentifier: bookID)?.appendingPathComponent("Images")
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
    
    static func getBookDirectory(ofBookWithIdentifier identifier: (author: String, title: String)) -> URL? {
        return LocalPlugin.getApplicationSupportAppDirectory()?.appendingPathComponent("Books/\(identifier.author)/\(identifier.title)")
    }
    
    enum LocalPluginLibraryPageType {
        case homepage
    }
}
