//
//  LocalPluginSeries.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 10. 28..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Cocoa

class LocalPluginSeries: Series {
    let url: URL
    lazy var rootElement: XMLElement = XMLElement(kind: .element)
    
    init(url: URL) {
        self.url = url
        super.init(owner: LocalPlugin.sharedInstance, identifier: url)
        parse()
        for ext in LocalPlugin.supportedImageExtensions {
            if let image = NSImage.init(contentsOf: url.appendingPathComponent("SeriesImage").appendingPathExtension(ext)) {
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
        let xmlLocation: URL = self.url.appendingPathComponent("SeriesData.xml")
        do {
            xmlDocument = try XMLDocument(contentsOf: xmlLocation, options: [])
            
            guard let rootElement = xmlDocument.rootElement() else {
                print("cannot get root element of series xml file: \(xmlLocation)")
                return
            }
            self.rootElement = rootElement
            
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
        }
        catch {
            print("cannot initialize XMLDocument from series xml file: \(url)")
        }
    }
}
