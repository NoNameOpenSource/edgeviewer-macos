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
    var id: Int
    var release: Int
    var series: Int
    var seriesName: String
    var numPages: Int
    //    lazy var chapters = [Int]()
    var bookmark: Int
    var rating: Double
    var updatedTime: Date?
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
                print(parser.parse())
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
            
            let book = Book(id: 5)
            book.title = title
            book.author = author
            book.release = release
            book.series = series
            book.seriesName = seriesName
            book.numPages = numPages
            //            book.chapters = chapters
            book.bookmark = bookmark
            book.rating = Int(rating)
            book.updatedTime = updatedTime
            
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
            else if eName == "series" {
                series = Int(data)!
            }
            else if eName == "seriesName" {
                seriesName = data
            }
            else if eName == "numPages" {
                numPages = Int(data)!
            }
                // // need to handle chapters array
                //            else if eName == "chapters" {
                //                chapters += data
                //            }
            else if eName == "bookmark" {
                bookmark = Int(data)!
            }
            else if eName == "rating" {
                rating = Double(data)!
            }
            else if eName == "updatedTime" {
                let dateFormatter = DateFormatter()
                if let time = dateFormatter.date(from: data) {
                    updatedTime = time
                }
                else {
                    print("Unable to retrieve date. Check formatting of date string.")
                    updatedTime = nil
                }
            }
            else if eName == "chapters" {
                let chaptersArray = data.split(separator: ",")
                var index = 0
                for char in chaptersArray {
                    chapters.append(Int(char)!)
                    index += 1
                }
                print(chapters)
            }
        }
    }
}
