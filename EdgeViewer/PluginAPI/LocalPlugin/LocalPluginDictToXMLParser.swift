//
//  LocalPluginDictToXMLParser.swift
//  EdgeViewer
//
//  Created by bmmkac on 7/15/19.
//  Copyright © 2019 NoName. All rights reserved.
//

import Foundation


class LocalPluginDictionarytoXMLSerializer{
    let url: URL
    lazy var rootElement: XMLElement = XMLElement(kind: .element)
    var book : Book!
    
    init(contentsOf url : URL){
        self.url = url
        self.book = Book(owner: LocalPlugin.sharedInstance, identifier: "", type: BookType.comic)
    }
    
    
    func xmlToDic() throws{
        try parse()
        try serialize()
    }
    
    private static func safeElement(withName elName: String, withProperty prop: Any?) -> XMLNode {
        var value = ""
        if let prop = prop {
            switch prop {
            case let prop as Double:
                value = String(prop)
            case let prop as String:
                value = prop
            case let prop as Int:
                value = String(prop)
            default:
                print("help me")
            }
        }
        return XMLNode.element(withName: elName, stringValue: value) as! XMLNode
    }
    
    func serialize() throws {
        var isDirectory:ObjCBool = ObjCBool(false)
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) else {
            throw LocalPlugin.SerializationError.missingDirectory
        }
        guard isDirectory.boolValue == true else {
            throw LocalPlugin.SerializationError.missingDirectory
        }
        
        let xmlDocument: XMLDocument = XMLDocument(rootElement: XMLElement(name: "dict"))
        let xmlLocation: URL = self.url.appendingPathComponent("BookDict.xml")
        guard let localRootElement = xmlDocument.rootElement() else {
            throw LocalPlugin.SerializationError.xmlSerializationError
        }
        
        // XML version
        xmlDocument.version = "1.0"
        
        localRootElement.addChild(XMLNode.element(withName: "title", stringValue: self.book.title) as! XMLNode)
        localRootElement.addChild(XMLNode.element(withName: "author", stringValue: self.book.author ?? "") as! XMLNode)
        localRootElement.addChild(XMLNode.element(withName: "genre", stringValue: self.book.genre ?? "") as! XMLNode)
        localRootElement.addChild(XMLNode.element(withName: "seriesName", stringValue: self.book.seriesName ?? "") as! XMLNode)
        localRootElement.addChild(XMLNode.element(withName: "bookmark", stringValue: String(self.book.bookmark)) as! XMLNode)
        localRootElement.addChild(XMLNode.element(withName: "currentPage", stringValue: String(self.book.currentPage)) as! XMLNode)
        
        let chaptersElements = rootElement.elements(forName: "chapters")
        if (chaptersElements.count == 1) {
            let chaptersElement = chaptersElements[0]
            let chapters = chaptersElement.elements(forName: "chapter")
            self.book.chapters = [Chapter]()
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
                                    self.book.chapters!.append(Chapter(title: title, pageIndex: pageIndexInt))
                                }
                            }
                        }
                    }
                }
            }
        }

        
        
        if let lastUpdated = self.book.lastUpdated {
            let RFC3339DateFormatter = DateFormatter()
            RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
            RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssv"
            RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            let lastupdateNode = XMLElement.init(name: "date", stringValue: RFC3339DateFormatter.string(from: lastUpdated))
            localRootElement.addChild(XMLNode.element(withName: "lastUpdated", stringValue: RFC3339DateFormatter.string(from: lastUpdated)) as! XMLNode)
        } else {
            let lastupdateNode = XMLElement.init(name: "date", stringValue: "Unknown Release")
            localRootElement.addChild(XMLNode.element(withName: "lastUpdated", stringValue: "Unknown Release Date") as! XMLNode)
        }
        
        let xmlDataString = xmlDocument.xmlData(options:[.nodePrettyPrint, .nodeCompactEmptyElement])
        
        try xmlDataString.write(to: xmlLocation)
    }
    
    
    
    
    
    func elementValue(ofElementWithName elName: String, ofElementWithType elType : String, ofElementWithRoot elRoot : XMLElement) -> Any? {
        let els = elRoot.elements(forName: elType)
        var elements : [XMLElement] = []
        for el in els{
            if el.attribute(forName: "name")?.stringValue == elName{
                elements.append(el)
            }
        }
        if (elements.count == 1) {
            if let el = elements[0].stringValue {
                switch elType {
                case "int":
                    if let el = Int(el) {
                        return el
                    }
                case "double":
                    if let el = Double(el) {
                        return el
                    }
                case "string":
                    return el
                default:
                    break
                }
                
            }
        }
        return nil
    }
    
    
    func parse() throws {
        var xmlDocument: XMLDocument
        let xmlLocation: URL = self.url.appendingPathComponent("BookData.xml")
        xmlDocument = try XMLDocument(contentsOf: xmlLocation, options: [])
        
        guard let localRootElement = xmlDocument.rootElement() else {
            throw LocalPlugin.ParsingError.missingDataFile
        }
        
        rootElement = localRootElement
        
        if let authorElementValue = elementValue(ofElementWithName: "author", ofElementWithType: "string", ofElementWithRoot: rootElement) {
            self.book.author = authorElementValue as? String
        }
        if let genreElementValue = elementValue(ofElementWithName: "genre", ofElementWithType: "string", ofElementWithRoot: rootElement) {
            self.book.genre = genreElementValue as? String
        }
        guard let titleElementValue = elementValue(ofElementWithName: "title", ofElementWithType: "string", ofElementWithRoot: rootElement) else {
            throw LocalPlugin.ParsingError.missingDataField("title")
        }
        self.book.title = titleElementValue as! String
        
        if let series = elementValue(ofElementWithName: "series", ofElementWithType: "string", ofElementWithRoot: rootElement) {
            self.book.seriesID = series
        }
        
        if let seriesName = elementValue(ofElementWithName: "series name", ofElementWithType: "string", ofElementWithRoot: rootElement) {
            self.book.seriesName = seriesName as? String
        }
        if let type = elementValue(ofElementWithName: "type", ofElementWithType: "string", ofElementWithRoot: rootElement) as? String{
            switch type {
            case "manga":
                self.book.type = .manga
            case "comic":
                self.book.type = .comic
            case "webManga":
                self.book.type = .webManga
            default:
                XMLCorrupt()
            }
        }
        
        
        
        
        
        
        
        // TODO: consider using switch statement
        
        
        
        
        if let bookmark = elementValue(ofElementWithName: "bookmark", ofElementWithType: "int", ofElementWithRoot: rootElement) as? Int {
            self.book.bookmark = bookmark
        }
        else {
            self.book.bookmark = 0
            XMLCorrupt()
            print("XML Parsing Error: Could not retrieve saved bookmark")
        }
        if let rating = elementValue(ofElementWithName: "rating", ofElementWithType: "double", ofElementWithRoot: rootElement) as? Double {
            self.book.rating = rating
        }
        else {
            self.book.rating = 0
            print("XML Parsing Error: Could not retrieve saved rating")
        }
        if let lastUpdated = elementValue(ofElementWithName: "lastUpdated", ofElementWithType: "date", ofElementWithRoot: rootElement) as? String {
            let RFC3339DateFormatter = DateFormatter()
            RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
            RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssv"
            RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            if let time = RFC3339DateFormatter.date(from: lastUpdated) {
                self.book.lastUpdated = time
            } else {
                self.book.lastUpdated = nil
                print("Unable to retrieve date. Check formatting of date string.")
            }
        }
        if let currentPage = elementValue(ofElementWithName: "currentPage", ofElementWithType: "int", ofElementWithRoot: rootElement) as? Int {
            self.book.currentPage = currentPage
        }
        else {
            self.book.currentPage = 0
            print("XML Parsing Error: Could not retrieve saved currentPage.")
        }
        
        if let readingMode = elementValue(ofElementWithName: "readingMode", ofElementWithType: "string", ofElementWithRoot: rootElement) as? String {
            switch readingMode {
            case "leftToRight":
                self.book.readingMode = .leftToRight
            case "rightToLeft":
                self.book.readingMode = .rightToLeft
            default:
                XMLCorrupt()
            }
        }
        let chaptersElements = rootElement.elements(forName: "array")
        if (chaptersElements.count == 1) {
            let chaptersElement = chaptersElements[0]
            let chapters = chaptersElement.elements(forName: "dict")
            self.book.chapters = [Chapter]()
            for chapter in chapters {
                if let title = elementValue(ofElementWithName: "title", ofElementWithType: "string", ofElementWithRoot: chapter) as? String{
                    if let pageIndex = elementValue(ofElementWithName: "pageIndex", ofElementWithType: "int", ofElementWithRoot: chapter) as? Int{
                        self.book.chapters!.append(Chapter(title: title, pageIndex: pageIndex))
                    }
                }
            }
        }
        
    }
    
    
    
    
    func XMLCorrupt() {
        print("XML book file is corrupt")
    }
}


