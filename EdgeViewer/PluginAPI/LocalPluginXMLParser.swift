//
//  LocalPlugin.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 4/28/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Foundation

class LocalPluginXMLParser: NSObject, XMLParserDelegate {
    
    var currentElement: Any
    var eName: String
    
    override init() {
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
        switch elementName {
        case "book":
            currentElement = Book(id: 0, plugin: LocalPlugin())
        case "chapters":
            currentElement = [Chapter]()
        default:
            print("help me!")
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: (NSCharacterSet.whitespacesAndNewlines) )
        
        switch currentElement {
        case let book as Book:
            if eName == "title" {
                book.title = data
            }
            else if eName == "author" {
                book.author = data
            }
            else if eName == "release" {
                book.release = Int(data)!
            }
            else if eName == "genre" {
                book.genre = data
            }
            else if eName == "series" {
                book.series = Int(data)!
            }
            else if eName == "seriesName" {
                book.seriesName = data
            }
            else if eName == "numPages" {
                book.numPages = Int(data)!
            }
            
            else if eName == "bookmark" {
                if let safeBookmark = Int(data) {
                    book.bookmark = safeBookmark
                }
                else {
                    print("XML Parsing Error: Could not retrieve saved bookmark.")
                    book.bookmark = 0
                }
            }
            else if eName == "rating" {
                if let safeRating = Double(data) {
                    book.rating = safeRating
                }
                else {
                    print("XML Parsing Error: Could not retrieve saved rating.")
                    book.rating = 0
                }
            }
            else if eName == "updatedTime" {
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
            }
            else if eName == "type" {
                if data == "manga" {
                    book.type = .manga
                }
                else if data == "comic" {
                    book.type = .comic
                }
                else if data == "webManga" {
                    book.type = .webManga
                }
            }
        case let chapters as [Chapter]:
            if eName == "chapter" {
                chapters.append(Chapter(title: data, pageIndex: <#T##Int#>))
            }
        default:
            print("help me! o my")
        }
        
        if (!data.isEmpty) {
        }
    }
}
