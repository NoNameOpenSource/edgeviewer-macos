//
//  LocalPlugin.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 4/28/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Foundation

class LocalPluginXMLParser: NSObject, XMLParserDelegate {
    
    var book: Book
    var chapters: [Chapter]
    var currentChapter: Chapter
    var currentChapterTitle: String
    var currentChapterPageIndex: Int
    
    override init() {
        book = Book(id: 0)
        chapters = [Chapter]()
        currentChapter = Chapter(title: "unimiportant", pageIndex: 5)
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
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "chapter" {
            chapters.append(Chapter(title: currentChapterTitle, pageIndex: currentChapterPageIndex))
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: (NSCharacterSet.whitespacesAndNewlines) )
        
        switch string {
        case "title":
            print(data)
            book.title = data
        case "author":
            book.author = data
        case "release":
            book.release = Int(data)!
        case "genre":
            book.genre = data
        case "series":
            book.series = Int(data)!
        case "seriesName":
            book.seriesName = data
        case "numPages":
            book.numPages = Int(data)!
        case "bookmark":
            if let safeBookmark = Int(data) {
                book.bookmark = safeBookmark
            }
            else {
                print("XML Parsing Error: Could not retrieve saved bookmark.")
                book.bookmark = 0
            }
        case "rating":
            if let safeRating = Double(data) {
                book.rating = safeRating
            }
            else {
                print("XML Parsing Error: Could not retrieve saved rating.")
                book.rating = 0
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
            if data == "manga" {
                book.type = .manga
            }
            else if data == "comic" {
                book.type = .comic
            }
            else if data == "webManga" {
                book.type = .webManga
            }
        case "chapterTitle":
            currentChapterTitle = data
        case "chapterPageIndex":
            if let data = Int(data) { currentChapterPageIndex = data }
            else { XMLCorrupt() }
        default:
            break
        }
        
        if (!data.isEmpty) {
        }
    }
    
    func XMLCorrupt() {
        print("XML book file is corrupt")
    }
}
