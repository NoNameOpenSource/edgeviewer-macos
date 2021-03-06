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
    var page: [String] = []
    lazy var rootElement: XMLElement = XMLElement(kind: .element)
    
    init(url: URL) throws {
        self.url = url
        super.init(owner: LocalPlugin.sharedInstance, identifier: url, type: .manga)
        try parse()
        loadCoverImage()
        try indexPages()
    }
    
    init(withCreatingBookAt url: URL, title: String) throws {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: url.path) == false else {
            // directory already exist
            throw ImportingBookError.directoryAlreadyExist
        }
        
        try fileManager.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
        
        self.url = url
        super.init(owner: LocalPlugin.sharedInstance, identifier: url, type: .manga)
        self.title = title
    }
    
    func loadCoverImage() {
        let possibleCovers = ["cover", "0", "1"]
        for i in 0..<possibleCovers.count {
            let possibleCover = possibleCovers[i]
            for ext in LocalPlugin.supportedImageExtensions {
                if let image = NSImage.init(contentsOf: url.appendingPathComponent("Images/\(possibleCover)").appendingPathExtension(ext)) {
                    coverImage = image
                    page.append("\(possibleCover).\(ext)")
                    return
                }
            }
        }
    }
    
    func indexPages() throws {
        let fileManager = FileManager.default
        var files = try fileManager.contentsOfDirectory(atPath: url.appendingPathComponent("Images").path)
        var coverExist = false
        if page.count == 1 { // the cover exist
            files.remove(at: files.firstIndex(of: page[0]) as! Int)
            coverExist = true
        }
        var names: [(String, String)] = []
        for i in 0..<files.count {
            let url = URL(string: files[i])
            if let url = url,
               LocalPlugin.supportedImageExtensions.firstIndex(of: url.pathExtension) != nil {
                names.append((files[i], url.deletingPathExtension().path))
            }
        }
        names.sort(by: { a, b in
            let aInt = Int(a.1) ?? Int(a.1.split(separator: "-")[0])
            let bInt = Int(b.1) ?? Int(b.1.split(separator: "-")[0])
            if let aInt = aInt, let bInt = bInt {
                return aInt < bInt
            }
            if aInt == nil, bInt == nil {
                return a.1 < b.1
            }
            if aInt == nil { // and bInt != nil
                return true
            }
            return false // aInt != nil, bInt == nil
        })
        for i in 0..<names.count {
            page.append(names[i].0)
        }
        
        if !coverExist && page.count > 0,
           let coverImage = NSImage.init(contentsOf: url.appendingPathComponent("Images/\(page.first!)")) {
            self.coverImage = coverImage
        }
        
        numberOfPages = page.count
    }
    
    override func page(atIndex index: Int) -> NSImage? {
        guard -1 < index && index < page.count else {
            print("Could not get file paths: page \(index) does not exist in this book")
            return nil
        }
        let url = self.url.appendingPathComponent("Images/\(page[index])")
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("Could not get file at path: \(url.absoluteString)")
            return nil
        }
        
        return NSImage(contentsOf: url)
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
        let xmlLocation: URL = self.url.appendingPathComponent("BookData.xml")
        xmlDocument = try XMLDocument(contentsOf: xmlLocation, options: [])
        
        guard let localRootElement = xmlDocument.rootElement() else {
            throw LocalPlugin.ParsingError.missingDataFile
        }
        
        rootElement = localRootElement
        
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
        if let series = elementValue(ofElementWithName: "series") as? String {
            self.series = series
        }
        if let seriesName = elementValue(ofElementWithName: "seriesName") as? String {
            self.seriesName = seriesName
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
            if let readingMode = elementValue(ofElementWithName: "readingMode") as? String {
                switch readingMode {
                case "leftToRight":
                    self.readingMode = .leftToRight
                case "rightToLeft":
                    self.readingMode = .rightToLeft
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
        localRootElement.addChild(XMLNode.element(withName: "seriesName", stringValue: seriesName ?? "") as! XMLNode)
        localRootElement.addChild(XMLNode.element(withName: "bookmark", stringValue: String(bookmark)) as! XMLNode)
        localRootElement.addChild(XMLNode.element(withName: "currentPage", stringValue: String(currentPage)) as! XMLNode)
        if let rating = rating {
            localRootElement.addChild(XMLNode.element(withName: "rating", stringValue: String(rating)) as! XMLNode)
        }
        
        // chapters
        var chapterNodes = [XMLNode]()
        if let chapters = chapters {
            for chapter in chapters {
                let chapterTitle = XMLNode.element(withName: "title", stringValue: chapter.title)
                let chapterPageIndex = XMLNode.element(withName: "pageIndex", stringValue: String(chapter.pageIndex))
                chapterNodes.append(XMLNode.element(withName: "chapter", children: [chapterTitle as! XMLNode, chapterPageIndex as! XMLNode], attributes: nil) as! XMLNode)
            }
        }
        localRootElement.addChild(XMLNode.element(withName: "chapters", children: chapterNodes, attributes: nil) as! XMLNode)
        
        // bookType
        let bookType: String
        switch type {
        case .manga:
            bookType = "manga"
        case .comic:
            bookType = "comic"
        case .webManga:
            bookType = "webManga"
        }
        localRootElement.addChild(XMLNode.element(withName: "type", stringValue: bookType) as! XMLNode)
        
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
