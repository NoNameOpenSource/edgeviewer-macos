//
//  LocalPluginBook.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 10/22/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class LocalPluginBook: Book {
    init(identifier: (series: String, title: String)) {
        super.init(owner: LocalPlugin.sharedInstance, identifier: 0, type: .manga)
        parse(identifier: identifier)
    }
    
    func XMLCorrupt() {
        print("XML book file is corrupt")
    }
    
    func parse(identifier: (String, String)) {
        var xmlDocument: XMLDocument
        let bookDirectory = LocalPlugin.getBookDirectory(ofBookWithIdentifier: identifier)
        let url: URL = (bookDirectory?.appendingPathComponent("BookData.xml"))!
        do {
            xmlDocument = try XMLDocument(contentsOf: url, options: [])
            guard let rootElement = xmlDocument.rootElement() else {
                print("cannot get root element of series xml file: \(url)")
                return
            }
            guard let titleElementValue = rootElement.elements(forName: "title")[0].stringValue else {
                print("cannot get title element value")
                return
            }
            self.title = titleElementValue
            
            // TODO: consider using switch statement
            if let authorElementValue = rootElement.elements(forName: "author")[0].stringValue {
                self.author = authorElementValue
            }
            if let genreElementValue = rootElement.elements(forName: "genre")[0].stringValue {
                self.genre = genreElementValue
            }
            if let seriesElementValue = rootElement.elements(forName: "series")[0].stringValue {
                self.series = seriesElementValue
            }
            if let seriesNameElementValue = rootElement.elements(forName: "seriesName")[0].stringValue {
                self.seriesName = seriesNameElementValue
            }
            if let numberOfPagesElementValue = rootElement.elements(forName: "numberOfPages")[0].stringValue {
                if let numberOfPagesElementValue = Int(numberOfPagesElementValue) {
                    self.numberOfPages = numberOfPagesElementValue
                }
                else {
                    self.numberOfPages = 0
                    XMLCorrupt()
                }
            }
            if let bookmarkElementValue = rootElement.elements(forName: "bookmark")[0].stringValue {
                if let bookmarkElementValue = Int(bookmarkElementValue) {
                    self.bookmark = bookmarkElementValue
                }
                else {
                    self.bookmark = 0
                    print("XML Parsing Error: Could not retrieve saved bookmark.")
                }
            }
            if let ratingElementValue = rootElement.elements(forName: "rating")[0].stringValue {
                if let ratingElementValue = Double(ratingElementValue) {
                    self.rating = ratingElementValue
                }
                else {
                    self.rating = 0
                    XMLCorrupt()
                }
            }
            if let lastUpdatedElementValue = rootElement.elements(forName: "lastUpdated")[0].stringValue {
                let RFC3339DateFormatter = DateFormatter()
                RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
                RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssv"
                RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                if let time = RFC3339DateFormatter.date(from: lastUpdatedElementValue) {
                    self.lastUpdated = time
                } else {
                    self.lastUpdated = nil
                    print("Unable to retrieve date. Check formatting of date string.")
                }
            }
            if let currentPageElementValue = rootElement.elements(forName: "currentPage")[0].stringValue {
                if let currentPageElementValue = Int(currentPageElementValue) {
                    self.currentPage = currentPageElementValue
                }
                else {
                    self.bookmark = 0
                    print("XML Parsing Error: Could not retrieve saved bookmark.")
                }
            }
            if let typeElementValue = rootElement.elements(forName: "type")[0].stringValue {
                switch typeElementValue {
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
            let chaptersElement = rootElement.elements(forName: "chapters")[0]
            let chapterElements = chaptersElement.elements(forName: "chapter")
            for chapterElement in chapterElements {
                if let titleElementValue = chapterElement.elements(forName: "title")[0].stringValue {
                    if let pageIndexElementValueString = chapterElement.elements(forName: "pageIndex")[0].stringValue {
                        if let pageIndexElementValueInt = Int(pageIndexElementValueString) {
                            self.chapters!.append(Chapter(title: titleElementValue, pageIndex: pageIndexElementValueInt))
                        }
                    }
                }
            }
        }
        catch {
            print("cannot initialize XMLDocument from series xml file: \(url)")
        }
    }
}
