//
//  LocalPluginXMLtoDictParser.swift
//  EdgeViewer
//
//  Created by bmmkac on 6/19/19.
//  Copyright © 2019 NoName. All rights reserved.
//

import Foundation

class LocalPluginXMLtoDictParser{
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
        
        let titleNode = XMLElement.init(name: "string", stringValue: self.book.title)
        titleNode.addAttribute(XMLNode.attribute(withName: "name", stringValue: "title") as! XMLNode)
        let authorNode = XMLElement.init(name: "string", stringValue: self.book.author ?? "")
        authorNode.addAttribute(XMLNode.attribute(withName: "name", stringValue: "author")as! XMLNode)
        let genreNode = XMLElement.init(name: "string", stringValue: self.book.genre ?? "")
        genreNode.addAttribute(XMLNode.attribute(withName: "name", stringValue: "genre")as! XMLNode)
        
        let sNameNode = XMLElement.init(name: "string", stringValue: self.book.seriesName ?? "")
        sNameNode.addAttribute(XMLNode.attribute(withName: "name", stringValue: "series name") as! XMLNode)
        let bookMarkNode = XMLElement.init(name: "int", stringValue: String(self.book.bookmark))
        bookMarkNode.addAttribute(XMLNode.attribute(withName: "name", stringValue: "bookmark") as! XMLNode)
        let cPageNode = XMLElement.init(name: "int", stringValue: String(self.book.currentPage))
        cPageNode.addAttribute(XMLNode.attribute(withName: "name", stringValue: "current page") as! XMLNode)
        
        
        
        
        localRootElement.addChild(titleNode as XMLNode)
        localRootElement.addChild(authorNode as XMLNode)
        localRootElement.addChild(genreNode as XMLNode)
        localRootElement.addChild(sNameNode as XMLNode)
        localRootElement.addChild(bookMarkNode as XMLNode)
        localRootElement.addChild(cPageNode as XMLNode)
        if let rating = self.book.rating {
            
            let ratingNode = XMLElement.init(name: "Double", stringValue: String(rating))
            ratingNode.addAttribute(XMLNode.attribute(withName: "name", stringValue: "rating") as! XMLNode)
            localRootElement.addChild(XMLNode.element(withName: "rating", stringValue: String(rating)) as! XMLNode)
        }
        
        // chapters
        var chapterNodes = [XMLNode]()
        if let chapters = self.book.chapters {
            for chapter in chapters {
                let chapterTitle = XMLNode.element(withName: "string", stringValue: chapter.title) as! XMLElement
                chapterTitle.addAttribute(XMLNode.attribute(withName: "name", stringValue: "title") as! XMLNode)
                let chapterPageIndex = XMLNode.element(withName: "int", stringValue: String(chapter.pageIndex)) as! XMLElement
                chapterPageIndex.addAttribute(XMLNode.attribute(withName: "name", stringValue: "pageIndex") as! XMLNode)
                let chapterNode = XMLNode.element(withName: "dict", children: [chapterTitle as! XMLNode, chapterPageIndex as! XMLNode], attributes: nil) as! XMLElement
                chapterNode.addAttribute(XMLNode.attribute(withName: "name", stringValue: "chapter") as! XMLNode)
                chapterNodes.append(chapterNode as XMLNode)
            }
        }
        let chapters = XMLNode.element(withName: "array", children: chapterNodes, attributes: nil) as! XMLElement
        chapters.addAttribute(XMLNode.attribute(withName: "name", stringValue: "chapters") as! XMLNode)
        localRootElement.addChild(chapters as XMLNode)
        
        // bookType
        let bookType: String
        switch self.book.type {
        case .manga:
            bookType = "manga"
        case .comic:
            bookType = "comic"
        case .webManga:
            bookType = "webManga"
        }
        let typeNode = XMLNode.element(withName: "string", stringValue: bookType) as! XMLElement
        typeNode.addAttribute(XMLNode.attribute(withName: "name", stringValue: "type") as! XMLNode)
        localRootElement.addChild(typeNode)
        
        // lastUpdated
        if let lastUpdated = self.book.lastUpdated {
            let RFC3339DateFormatter = DateFormatter()
            RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
            RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssv"
            RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            let lastupdateNode = XMLElement.init(name: "date", stringValue: RFC3339DateFormatter.string(from: lastUpdated))
            lastupdateNode.addAttribute(XMLNode.attribute(withName: "name", stringValue: "lastUpadate") as! XMLNode)
            localRootElement.addChild(lastupdateNode as XMLNode)
        } else {
            let lastupdateNode = XMLElement.init(name: "date", stringValue: "Unknown Release")
            lastupdateNode.addAttribute(XMLNode.attribute(withName: "name", stringValue: "lastUpadate") as! XMLNode)
            localRootElement.addChild(lastupdateNode as XMLNode)
        }
        
        let xmlDataString = xmlDocument.xmlData(options:[.nodePrettyPrint, .nodeCompactEmptyElement])
        
        try xmlDataString.write(to: xmlLocation)
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
    
    func XMLCorrupt() {
        print("XML book file is corrupt")
    }
}
