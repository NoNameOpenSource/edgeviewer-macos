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
    
    init(url: URL) throws {
        self.url = url
        super.init(owner: LocalPlugin.sharedInstance, identifier: url)
        try parse()
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
    
    func parse() throws {
        var xmlDocument: XMLDocument
        let xmlLocation: URL = self.url.appendingPathComponent("SeriesData.xml")
        do {
            xmlDocument = try XMLDocument(contentsOf: xmlLocation, options: [])
            
            guard let rootElement = xmlDocument.rootElement() else {
                throw LocalPlugin.ParsingError.missingDataFile
            }
            self.rootElement = rootElement
            
            guard let titleElementValue = rootElement.elements(forName: "title")[0].stringValue else {
                throw LocalPlugin.ParsingError.missingDataField("title")
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
    
    func serialize() throws {
        var isDirectory:ObjCBool = ObjCBool(false)
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) else {
            throw LocalPlugin.SerializationError.missingDirectory
        }
        guard isDirectory.boolValue == true else {
            throw LocalPlugin.SerializationError.missingDirectory
        }
        
        let xmlDocument: XMLDocument = XMLDocument(rootElement: XMLElement(name: "book"))
        let xmlLocation: URL = self.url.appendingPathComponent("BookData.xml")
        guard let localRootElement = xmlDocument.rootElement() else {
            throw LocalPlugin.SerializationError.xmlSerializationError
        }
        
        // XML version
        xmlDocument.version = "1.0"
        
        localRootElement.addChild(XMLNode.element(withName: "title", stringValue: title) as! XMLNode)
        localRootElement.addChild(XMLNode.element(withName: "author", stringValue: author ?? "") as! XMLNode)
        localRootElement.addChild(XMLNode.element(withName: "genre", stringValue: genre ?? "") as! XMLNode)
        localRootElement.addChild(XMLNode.element(withName: "rating", stringValue: String(rating!)) as! XMLNode)
        
        // lastUpdated
        if let lastUpdated = lastUpdated {
            let RFC3339DateFormatter = DateFormatter()
            RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
            RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssv"
            RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            localRootElement.addChild(XMLNode.element(withName: "lastUpdated", stringValue: RFC3339DateFormatter.string(from: lastUpdated)) as! XMLNode)
        } else {
            localRootElement.addChild(XMLNode.element(withName: "lastUpdated", stringValue: "Unknown Release Date") as! XMLNode)
        }
        
        let xmlDataString = xmlDocument.xmlData(options:[.nodePrettyPrint, .nodeCompactEmptyElement])
        
        try xmlDataString.write(to: xmlLocation)
    }
}
