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
    static let supportedImageExtensions = ["jpg", "png"]
    
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
            let series = loadSeries(inFolder: booksDirectory!)
            for series in series {
                let pageItem = PageItem(owner: self, series: series)
                pageItem.thumbnail = series.coverImage
                page.items.append(pageItem)
            }
            let books = loadBooks(inFolder: booksDirectory!)
            for book in books {
                let pageItem = PageItem(owner: self, book: book)
                pageItem.thumbnail = book.coverImage
                page.items.append(pageItem)
            }
        default:
            print("unhandled LibraryPageType: \(identifier)")
            break
        }
        return page
    }
    
    func loadSeries(inFolder folder: URL) -> [LocalPluginSeries] {
        var returnSeries: [LocalPluginSeries] = []
        guard let files = try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil, options: []) else {
            return returnSeries
        }
        
        for file in files {
            if FileManager.default.fileExists(atPath: file.appendingPathComponent("SeriesData.xml").path) {
                let series = LocalPluginSeries(url: file)
                returnSeries.append(series)
            }
        }
        
        return returnSeries
    }
    
    func loadBooks(inFolder folder: URL) -> [LocalPluginBook] {
        let unknownSeriesIdentifier = "--Unknown Series--"
        var books: [LocalPluginBook] = []
        guard let files = try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil, options: []) else {
            return books
        }
        
        for file in files {
            if FileManager.default.fileExists(atPath: file.appendingPathComponent("BookData.xml").path) {
                let book = LocalPluginBook(url: file)
                books.append(book)
            }
        }
        
        return books
    }
    
    func page(withIdentifier identifier: Any) -> LibraryPage? {
        return nil
    }
    
    func book(withIdentifier identifier: Any) -> Book? {
        guard let url = identifier as? URL else {
            print("identifier is bad")
            return nil
        }
        let book = LocalPluginBook(url: url)
        return book
    }
    
    func series(withIdentifier identifier: Any) -> Series? {
        var xmlParser: LocalPluginSeriesXMLParser?
        var seriesImage: NSImage?
        if let identifier = identifier as? String {
            let booksDirectory = LocalPlugin.getApplicationSupportAppDirectory()?.appendingPathComponent("Books")
            let fileManager = FileManager.default
            do {
                let seriesFolders = try fileManager.contentsOfDirectory(at: booksDirectory!, includingPropertiesForKeys: nil, options: [])
                for (seriesFolder) in seriesFolders {
                    if seriesFolder.lastPathComponent == identifier {
                        let seriesXMLFile = seriesFolder.appendingPathComponent("SeriesData.xml")
                        xmlParser = LocalPluginSeriesXMLParser(contentsOf: seriesXMLFile)
                        let filePaths = try fileManager.contentsOfDirectory(at: seriesFolder, includingPropertiesForKeys: nil, options: [])
                        for filePath in filePaths {
                            if filePath.lastPathComponent.hasPrefix("SeriesImage.") {
                                seriesImage = NSImage(contentsOf: filePath)
                            }
                        }
                    }
                }
            }
            catch {
                print("cannot get series folders")
                return nil
            }
        }
        if let xmlParser = xmlParser {
            let series =  xmlParser.series
            if let series = series {
                if let seriesImage = seriesImage {
                    series.coverImage = seriesImage
                }
            }
            return series
        }
        else {
            print("cannot get series object")
            return nil
        }
    }
    
    func books(ofSeries series: Series) -> [Book]? {
        guard let series = series as? LocalPluginSeries else { return nil }
        let books = loadBooks(inFolder: series.url)
        
        return books
    }
    
    func page(ofBook book: Book, pageNumber: Int) -> NSImage? {
        guard let book = book as? LocalPluginBook else {
            return nil
        }
        let bookImageDirectory: URL? = book.url.appendingPathComponent("Images")
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
    
    func update(series: Series) {
        LocalPluginXMLStorer.storeSeriesData(ofSeries: series)
    }
    
    func update(currentPage: Int, ofBook book: Book) {
        book.currentPage = currentPage
        LocalPluginXMLStorer.storeBookData(ofBook: book)
    }
    
    func update(rating: Double, ofBook book: Book) {
        book.rating = rating
        LocalPluginXMLStorer.storeBookData(ofBook: book)
    }
    
    func update(rating: Double, ofSeries series: Series) {
        series.rating = rating
        LocalPluginXMLStorer.storeSeriesData(ofSeries: series)
    }
    
    static func getApplicationSupportAppDirectory() -> URL? {
        let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        if paths.count >= 1 {
            return NSURL(fileURLWithPath: paths[0], isDirectory: true).appendingPathComponent("EdgeViewer")
        }
        print("Could not find application support directory.")
        return nil
    }
    
    static func getBooksDirectory() -> URL? {
        return LocalPlugin.getApplicationSupportAppDirectory()?.appendingPathComponent("Books/")
    }
    
    static func getBookDirectory(ofBookWithIdentifier identifier: (series: String, title: String)) -> URL? {
        return LocalPlugin.getBooksDirectory()?.appendingPathComponent("\(identifier.series)/\(identifier.title)")
    }
    
    enum LocalPluginLibraryPageType {
        case homepage
    }
}
