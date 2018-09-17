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
    var homePage: LibraryPage {
        get {
            return page(withIdentifier: .homepage)!
        }
    }
    
    private init(name: String, version: Double) {
        self.name = name
        self.version = version
    }
    static var sharedInstance = LocalPlugin(name: "LocalPlugin", version: 0.1)
    
    func page(withIdentifier identifier: LocalPluginLibraryPageType) -> LibraryPage? {
        let page = LibraryPage(owner: self, identifier: identifier, type: .regular)
        switch identifier {
            case .homepage:
                let booksDirectory = LocalPlugin.getApplicationSupportAppDirectory()?.appendingPathComponent("Books")
                let fileManager = FileManager.default
                do {
                    let seriesFolders = try fileManager.contentsOfDirectory(at: booksDirectory!, includingPropertiesForKeys: nil, options: [])
                    for (seriesFolder) in seriesFolders {
                        if !seriesFolder.absoluteString.hasSuffix(".DS_Store") {
                            do {
                                let bookFolders = try fileManager.contentsOfDirectory(at: seriesFolder, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
                                for bookFolder in bookFolders {
                                    let pageItem = PageItem(owner: self, identifier: (seriesFolder.lastPathComponent, bookFolder.lastPathComponent), type: .book)
                                    pageItem.name = bookFolder.lastPathComponent
                                    page.items.append(pageItem)
                                }
                            }
                            catch {
                                print("cannot get series folders")
                                return nil
                            }
                        }
                    }
                }
                catch {
                    print("could not get contents of \(booksDirectory?.absoluteString ?? "")")
                    return nil
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
        xmlParser.book.identifier = (xmlParser.book.series, xmlParser.book.title)
        if let coverImage = xmlParser.book.page(atIndex: 0) {
            xmlParser.book.coverImage = coverImage
        }
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
    
    func update(book: Book) {
        LocalPluginXMLStorer.storeBookData(ofBook: book)
    }
    
    func update(currentPage: Int, ofBook book: Book) {
        book.currentPage = currentPage
        LocalPluginXMLStorer.storeBookData(ofBook: book)
    }
    
    func update(rating: Double, ofBook book: Book) {
        book.rating = rating
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
    
    static func getBookDirectory(ofBookWithIdentifier identifier: (series: String, title: String)) -> URL? {
        return LocalPlugin.getApplicationSupportAppDirectory()?.appendingPathComponent("Books/\(identifier.series)/\(identifier.title)")
    }
    
    enum LocalPluginLibraryPageType {
        case homepage
    }
}
