//
//  LocalPluginXMLParser.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 4/28/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Foundation

class LocalPluginXMLParser: NSObject, XMLParserDelegate {
    
    var book: Book
    
    private var eName: String
    private var chapters: [Chapter]
    private var currentChapter: Chapter
    private var currentChapterTitle: String
    private var currentChapterPageIndex: Int
    
    override init() {
        eName = String()
        book = Book(owner: LocalPlugin(), identifier: 0, type: .manga)
        chapters = [Chapter]()
        currentChapter = Chapter(title: "unimportant", pageIndex: 5)
        currentChapterTitle = ""
        currentChapterPageIndex = 0
        super.init()
        if let path = Bundle.main.url(forResource: "LocalLibrary", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                if !parser.parse() {
                    print("Failed to parse XML file for books.")
                }
            }
        }
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        eName = elementName
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "chapter" {
            chapters.append(Chapter(title: currentChapterTitle, pageIndex: currentChapterPageIndex))
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: (NSCharacterSet.whitespacesAndNewlines) )
        print(eName)
        
        if (!data.isEmpty) {
            switch eName {
            case "id":
                print("identifier: \(data)")
                if let data = Int(data) { book.identifier = data }
                else {
                    book.identifier = 0
                    print("identifier corrupt")
                    print(data)
                }
            case "title":
                print(data)
                book.title = data
            case "author":
                print(data)
                book.author = data
            case "genre":
                print(data)
                book.genre = data
            case "series":
                print("Series: \(data)")
                if let data = Int(data) { book.series = data}
                else {
                    book.series = 0
                    XMLCorrupt()
                }
            case "seriesName":
                book.seriesName = data
            case "numberOfPages":
                print("Series: \(data)")
                if let data = Int(data) { book.numberOfPages = data}
                else {
                    book.numberOfPages = 0
                    XMLCorrupt()
                }
            case "bookmark":
                if let data = Int(data) {
                    book.bookmark = data
                }
                else {
                    print("XML Parsing Error: Could not retrieve saved bookmark.")
                    book.bookmark = 0
                }
            case "rating":
                if let data = Double(data) {
                    book.rating = data
                }
                else {
                    book.rating = 0
                    XMLCorrupt()
                }
            case "updatedTime":
                let RFC3339DateFormatter = DateFormatter()
                RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
                RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                if let time = RFC3339DateFormatter.date(from: data) {
                    book.lastUpdated = time
                }
                else {
                    print("Unable to retrieve date. Check formatting of date string.")
                    book.lastUpdated = nil
                }
            case "type":
                switch data {
                case "manga":
                    book.type = .manga
                case "comic":
                    book.type = .comic
                case "webManga":
                    book.type = .webManga
                default:
                    XMLCorrupt()
                    break
                }
            case "chapterTitle":
                currentChapterTitle = data
            case "chapterPageIndex":
                if let data = Int(data) { currentChapterPageIndex = data }
                else { XMLCorrupt() }
            default:
                break
            }
        }
    }
    
    func XMLCorrupt() {
        print("XML book file is corrupt")
    }
}
