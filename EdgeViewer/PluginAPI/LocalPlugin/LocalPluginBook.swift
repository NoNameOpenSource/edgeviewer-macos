//
//  LocalPluginBook.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 10/22/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class LocalPluginBook: Book {
    let url: URL
    lazy var rootElement: XMLElement = XMLElement(kind: .element)
    
    init(url: URL) {
        self.url = url
        super.init(owner: LocalPlugin.sharedInstance, identifier: url, type: .manga)
        parse()
        for ext in LocalPlugin.supportedImageExtensions {
            if let image = NSImage.init(contentsOf: url.appendingPathComponent("Images/0").appendingPathExtension(ext)) {
                coverImage = image
                break
            }
        }
    }
    
    func XMLCorrupt() {
        print("XML book file is corrupt")
    }
    
    func elementValue(ofElementWithName elName: String) -> Any? {
        let els = rootElement.elements(forName: elName)
        if (els.count == 1) {
            if let el = els[0].stringValue {
                if let el = Int(el) {
                    return el
                }
                else if let el = Double(el) {
                    return el
                }
                else {
                    // el is a String
                    return el
                }
            }
            else {
                XMLCorrupt()
            }
        }
        else {
            XMLCorrupt()
        }
        return nil
    }
    
    func parse() {
        var xmlDocument: XMLDocument
        let xmlLocation: URL = self.url.appendingPathComponent("BookData.xml")
        do {
            xmlDocument = try XMLDocument(contentsOf: xmlLocation, options: [])
            
            guard let localRootElement = xmlDocument.rootElement() else {
                print("cannot get root element of series xml file: \(xmlLocation)")
                return
            }
            rootElement = localRootElement
            
            guard let titleElementValue = rootElement.elements(forName: "title")[0].stringValue else {
                print("cannot get title element value")
                return
            }
            self.title = titleElementValue
            
            // TODO: consider using switch statement
            if let author = elementValue(ofElementWithName: "author") as? String {
                self.author = author
            }
            if let genre = elementValue(ofElementWithName: "genre") as? String {
                self.genre = genre
            }
            if let series = elementValue(ofElementWithName: "series") as? String {
                self.series = series
            }
            if let seriesName = elementValue(ofElementWithName: "seriesName") as? String {
                self.seriesName = seriesName
            }
            if let numberOfPages = elementValue(ofElementWithName: "numberOfPages") as? Int {
                self.numberOfPages = numberOfPages
            }
            if let bookmark = elementValue(ofElementWithName: "bookmark") as? Int {
                self.bookmark = bookmark
            }
            else {
                self.bookmark = 0
                XMLCorrupt()
                print("XML Parsing Error: Could not retrieve saved bookmark")
            }
            if let rating = elementValue(ofElementWithName: "rating") as? Double {
                self.rating = rating
            }
            else {
                self.rating = 0
                XMLCorrupt()
                print("XML Parsing Error: Could not retrieve saved rating")
            }
            if let lastUpdated = elementValue(ofElementWithName: "lastUpdated") as? String {
                let RFC3339DateFormatter = DateFormatter()
                RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
                RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssv"
                RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                if let time = RFC3339DateFormatter.date(from: lastUpdated) {
                    self.lastUpdated = time
                } else {
                    self.lastUpdated = nil
                    print("Unable to retrieve date. Check formatting of date string.")
                }
            }
            if let currentPage = elementValue(ofElementWithName: "currentPage") as? Int {
                self.currentPage = currentPage
            }
            else {
                self.currentPage = 0
                print("XML Parsing Error: Could not retrieve saved currentPage.")
            }
            if let type = elementValue(ofElementWithName: "type") as? String {
                switch type {
                case "manga":
                    self.type = .manga
                case "comic":
                    self.type = .comic
                case "webManga":
                    self.type = .webManga
                default:
                    XMLCorrupt()
                }
            }
            let chaptersElements = rootElement.elements(forName: "chapters")
            if (chaptersElements.count == 1) {
                let chaptersElement = chaptersElements[0]
                let chapters = chaptersElement.elements(forName: "chapter")
                self.chapters = [Chapter]()
                for chapter in chapters {
                    let titleElements = chapter.elements(forName: "title")
                    if (titleElements.count == 1) {
                        let titleElement = titleElements[0]
                        if let title = titleElement.stringValue {
                            let pageIndexElements = titleElement.elements(forName: "pageIndex")
                            if (pageIndexElements.count == 1) {
                                let pageIndexElement = pageIndexElements[0]
                                if let pageIndex = pageIndexElement.stringValue {
                                    if let pageIndexInt = Int(pageIndex) {
                                        self.chapters!.append(Chapter(title: title, pageIndex: pageIndexInt))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        catch {
            print("cannot initialize XMLDocument from series xml file: \(xmlLocation)")
        }
    }
}
