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
    static let supportedImageExtensions = ["jpg", "png", "jpeg"]
    
    var homePage: LibraryPage {
        get {
            return page(withIdentifier: .homepage)!
        }
    }
    
    enum ParsingError: Error {
        case missingDataFile
        case missingDataField(String)
    }
    
    enum SerializationError: Error {
        case missingDirectory
        case xmlSerializationError
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
            let booksDirectory = LocalPlugin.getBooksDirectory()
            let series = loadSeries(inFolder: booksDirectory!)
            for series in series {
                let pageItem = PageItem(owner: self, series: series)
                for ext in LocalPlugin.supportedImageExtensions {
                    let url = series.url.appendingPathComponent("SeriesImage").appendingPathExtension(ext)
                    if FileManager.default.fileExists(atPath: url.path) {
                        let request = URLRequest(url: url)
                        pageItem.thumbnail = LazyImageView(request: request)
                        break
                    }
                }
                page.items.append(pageItem)
            }
            var books = loadBooks(inFolder: booksDirectory!)
            books = bookSort(bookList: books, sorterType: "title")
            print(books)
            for book in books {
                let pageItem = PageItem(owner: self, book: book)
                //let request = URLRequest(url: book.url.appendingPathComponent("Images/\(book.page[0])"))
                pageItem.thumbnail = book.pages[0].imageView
                page.items.append(pageItem)
            }
        default:
            print("unhandled LibraryPageType: \(identifier)")
            break
        }
        return page
    }
    
    func bookSort(bookList : [LocalPluginBook], sorterType : String)->[LocalPluginBook]{
        switch sorterType {
        case "date":
            return bookList.sorted(by: sorterForDate )
        case "title":
            return bookList.sorted(by: sorterForTtitle)
        case "author":
            return bookList.sorted(by: sorterForAuthor)
        default:
            return bookList.sorted(by: sorterForDate )
        }
        
    }
    
    func sorterForDate(first: Book,second: Book) -> Bool {
        guard first.lastUpdated != nil else {
            return false
        }
        guard second.lastUpdated != nil else {
            return true
        }
        
        return first.lastUpdated! > second.lastUpdated!
    }
    
    func sorterForTtitle(first: Book,second: Book)->Bool{
        var i : Int = 0
        let first_title = first.title
        let second_title = second.title
        while (first_title[i] == second_title[i]){
            i += 1
            if i >= first.title.count {
                return true
            }
            if i >= second.title.count {
                return false
            }
        }
        return first_title[i] > second_title[i]
    }
    
    func sorterForAuthor(first: Book, second:Book) -> Bool {
        var i = 0
        guard first.author != nil else{
            return false
        }
        guard second.author != nil else {
            return true
        }
        
        if first.author!.count == 0 {
            return false
        }
        if second.author!.count == 0 {
            return true
        }
        while first.author![i] == second.author![i]{
            i += 0
            if i >= first.author!.count {
                return true
            }
            if i >= second.author!.count {
                return false
            }
        }
        return first.author![i] > second.author![i]
    }
    
    
    
    
    
    func loadSeries(inFolder folder: URL) -> [LocalPluginSeries] {
        var returnSeries: [LocalPluginSeries] = []
        guard let files = try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil, options: []) else {
            return returnSeries
        }
        
        for file in files {
            if FileManager.default.fileExists(atPath: file.appendingPathComponent("SeriesData.xml").path) {
                if let series = try? LocalPluginSeries(url: file) {
                    returnSeries.append(series)
                } else {
                    // file curropted or missing
                    // this is not handled at this moment
                }
            }
        }
        
        return returnSeries
    }
    
    func loadBooks(inFolder folder: URL) -> [LocalPluginBook] {
        _ = "--Unknown Series--"
        var books: [LocalPluginBook] = []
        guard let files = try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil, options: []) else {
            return books
        }
        
        for file in files {
            if FileManager.default.fileExists(atPath: file.appendingPathComponent("BookData.xml").path) {
                if let book = try? LocalPluginBook(url: file) {
                    books.append(book)
                } else {
                    // file curropted or missing
                    // this is not handled at this moment
                }
            }
        }
        
        return books
    }
    
    func page(withIdentifier identifier: Any) -> LibraryPage? {
        guard let identifier = identifier as? LocalPluginLibraryPageType else { return nil }
        return page(withIdentifier: identifier)
    }
    
    func book(withIdentifier identifier: Any) -> Book? {
        guard let url = identifier as? URL else {
            print("identifier is bad")
            return nil
        }
        let book = try? LocalPluginBook(url: url)
        return book
    }
    
    func series(withIdentifier identifier: Any) -> Series? {
        var xmlParser: LocalPluginSeriesXMLParser?
        if let identifier = identifier as? String {
            let booksDirectory = LocalPlugin.getBooksDirectory()
            let fileManager = FileManager.default
            do {
                let seriesFolders = try fileManager.contentsOfDirectory(at: booksDirectory!, includingPropertiesForKeys: nil, options: [])
                for (seriesFolder) in seriesFolders {
                    if seriesFolder.lastPathComponent == identifier {
                        let seriesXMLFile = seriesFolder.appendingPathComponent("SeriesData.xml")
                        xmlParser = LocalPluginSeriesXMLParser(contentsOf: seriesXMLFile)
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
        for book in books {
            book.series = series
            book.seriesID = series.title
        }
        
        return books
    }
    
    func page(ofBook book: Book, pageIndex: Int) -> BookPage? {
        guard let book = book as? LocalPluginBook else {
            return nil
        }
        return book.pages[pageIndex]
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
        return LocalPlugin.getApplicationSupportAppDirectory()?.appendingPathComponent("Books")
    }
    
    static func getBookDirectory(ofBookWithIdentifier identifier: (series: String, title: String)) -> URL? {
        return LocalPlugin.getBooksDirectory()?.appendingPathComponent("\(identifier.series)/\(identifier.title)")
    }
    
    enum LocalPluginLibraryPageType {
        case homepage
    }
    
    func isSameBook(_ left: Book, _ right: Book) -> Bool {
        guard let left = left as? LocalPluginBook, let right = right as? LocalPluginBook else { return false }
        return left.url == right.url
    }
}

extension String {
    subscript (index: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return self[charIndex]
    }
    
    subscript (range: Range<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: range.startIndex)
        let stopIndex = self.index(self.startIndex, offsetBy: range.startIndex + range.count)
        return self[startIndex..<stopIndex]
    }
    
}
