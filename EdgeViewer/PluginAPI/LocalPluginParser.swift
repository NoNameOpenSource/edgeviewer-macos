//
//  TableViewController.swift
//  IOS9XMLParserTutorial
//
//  Created by Arthur Knopper on 31/05/16.
//  Copyright © 2016 Arthur Knopper. All rights reserved.
//

import Foundation

class LocalPluginParser: NSObject, XMLParserDelegate {
    
    var books: [Book]
    var eName: String
    var title: String
    var author: String
    var genre: String
    var id: Int
    var release: Int
    var series: Int
    var seriesName: String
    var numPages: Int
    //    lazy var chapters = [Int]()
    var bookmark: Int
    var rating: Double
    var releaseDate: Date?
    var chapters: [Int]
    enum type {
        case manga
        case comic
        case webManga
    }
    
    override init() {
        books = [Book]()
        eName = String()
        title = String()
        author = String()
        id = Int()
        release = Int()
        genre = String()
        series = Int()
        seriesName = String()
        numPages = Int()
        bookmark = Int()
        rating = Double()
        chapters = [Int]()
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
        if elementName == "book" {
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "book" {
            
            let book = Book(id: 0)
            book.title = title
            book.author = author
            book.genre = genre
            book.release = release
            book.series = series
            book.seriesName = seriesName
            book.numPages = numPages
            //            book.chapters = chapters
            book.bookmark = bookmark
            book.rating = Int(rating)
            book.releaseDate = releaseDate
            
            books.append(book)
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: (NSCharacterSet.whitespacesAndNewlines) )
        
        if (!data.isEmpty) {
            if eName == "title" {
                title = data
            }
            else if eName == "author" {
                author = data
            }
            else if eName == "release" {
                release = Int(data)!
            }
            else if eName == "genre" {
                genre = data
            }
            else if eName == "series" {
                series = Int(data)!
            }
            else if eName == "seriesName" {
                seriesName = data
            }
            else if eName == "numPages" {
                numPages = Int(data)!
            }
            else if eName == "chapters" {
                let chaptersArray = data.split(separator: ",")
                var index = 0
                for char in chaptersArray {
                    chapters.append(Int(char)!)
                    index += 1
                }
            }
            else if eName == "bookmark" {
                if let safeBookmark = Int(data) {
                    bookmark = safeBookmark
                }
                else {
                    print("XML Parsing Error: Could not retrieve saved bookmark.")
                    bookmark = 0
                }
            }
            else if eName == "rating" {
                if let safeRating = Double(data) {
                    rating = safeRating
                }
                else {
                    print("XML Parsing Error: Could not retrieve saved rating.")
                    bookmark = 0
                }
                rating = Double(data)!
            }
            else if eName == "updatedTime" {
                let RFC3339DateFormatter = DateFormatter()
                RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
                RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                if let time = RFC3339DateFormatter.date(from: data) {
                    releaseDate = time
                }
                else {
                    print("Unable to retrieve date. Check formatting of date string.")
                    releaseDate = nil
                }
            }
            
            else if eName == "type" {
                
            }
        }
    }
}
