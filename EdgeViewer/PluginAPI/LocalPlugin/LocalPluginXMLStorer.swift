//
//  LocalPluginStorer.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 5/14/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Foundation

final class LocalPluginXMLStorer { // pseudo-static class
    
    private init() {}
    
    static func storeBookData(ofBook book: Book) {
        guard let bookID = book.identifier as? (String, String) else {
            return
        }
        let bookDirectoryURL = LocalPlugin.getBookDirectory(ofBookWithIdentifier: bookID )

        // Create Book directory in user's Application Support directory
        do {
            try FileManager.default.createDirectory(at: bookDirectoryURL!, withIntermediateDirectories: true)
        }
        catch {
            print("Could not create directory: \(error)")
        }
        
        if let xmlDocumentLocation: URL = bookDirectoryURL?.appendingPathComponent("BookData.xml") {
            
            let xmlDataString = createXMLDocumentData(book: book)
            
            // Write XMLDocument contents to LocalLibrary.xml (overwrites, doesn't append)
            do {
                print(xmlDocumentLocation)
                try xmlDataString.write(to: xmlDocumentLocation)
            } catch {
                print(error)
            }
        }
        else { // if let xmlDocumentLocation
            print("Could not find \(book.title) folder in user's Application Support Directory")
        }
    }
    
    static func storeSeriesData(ofSeries series: Series) {
        guard let seriesID = series.identifier as? String else {
            print("series is not a String")
            return
        }
        guard let booksDirectory = LocalPlugin.getBooksDirectory() else {
            print("cannot get books directory")
            return
        }
        let seriesDirectory = booksDirectory.appendingPathComponent(seriesID)
        
        // Create directory for this series in Books directory within Application\ Support/EdgeViewer
        do {
            try FileManager.default.createDirectory(at: seriesDirectory, withIntermediateDirectories: true)
        }
        catch {
            print("Could not create directory: \(error)")
        }
        
        if let xmlDocumentLocation: URL = seriesDirectory.appendingPathComponent("SeriesData.xml") {
            let xmlDataString = createXMLDocumentData(forSeries: series)
            // Write XMLDocument contents to LocalLibrary.xml (overwrites, doesn't append)
            do {
                print(xmlDocumentLocation)
                try xmlDataString.write(to: xmlDocumentLocation)
            } catch {
                print(error)
            }
        }
        else { // if let xmlDocumentLocation
            print("Could not find \(series.title) folder in user's Application Support Directory")
        }
    }
    
    private static func createXMLDocumentData(forSeries series: Series) -> Data {
        let xmlDoc = XMLDocument(rootElement: XMLElement(name: "series"))
        
        xmlDoc.rootElement()?.addChild(safeElement(withName: "title", withProperty: series.title))
        xmlDoc.rootElement()?.addChild(safeElement(withName: "author", withProperty: series.author))
        xmlDoc.rootElement()?.addChild(safeElement(withName: "rating", withProperty: series.rating))
        xmlDoc.rootElement()?.addChild(safeElement(withName: "genre", withProperty: series.genre))
        
        // lastUpdated
        var lastUpdated: String
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssv"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let lastUpdatedDate = series.lastUpdated {
            lastUpdated = RFC3339DateFormatter.string(from: lastUpdatedDate)
        } else {
            print("date nil")
            lastUpdated = "Unknown Release Date"
        }
        xmlDoc.rootElement()?.addChild(safeElement(withName: "lastUpdated", withProperty: lastUpdated))
        
        // XML version
        xmlDoc.version = "1.0"
        
        // return the XMLDocument that has been assembled by the preceding code in this function
        return xmlDoc.xmlData(options:[.nodePrettyPrint, .nodeCompactEmptyElement])
    }
    
    private static func createXMLDocumentData(book: Book) -> Data {
        // Set up XMLDocument element with new values
        
        // root element
        let xmlDoc = XMLDocument(rootElement: XMLElement(name: "dict"))
        let title = XMLElement.init(name: "string", stringValue: book.title)
        title.addAttribute(XMLNode.attribute(withName: "name", stringValue: "title") as! XMLNode)
        let author = XMLElement.init(name: "string", stringValue: book.author)
        author.addAttribute(XMLNode.attribute(withName: "name", stringValue: "author")as! XMLNode)
        let genre = XMLElement.init(name: "string", stringValue: book.genre)
        genre.addAttribute(XMLNode.attribute(withName: "name", stringValue: "genre")as! XMLNode)
        
        
        xmlDoc.rootElement()?.addChild(title)
        
        xmlDoc.rootElement()?.addChild(author)
        xmlDoc.rootElement()?.addChild(genre)
        
        // chapters
        var chapters = [XMLNode]()
        if book.chapters != nil {
            for chapter in book.chapters! {
                let chapterTitle = XMLElement.init(name: "string", stringValue: chapter.title)
                chapterTitle.addAttribute(XMLNode.attribute(withName: "name", stringValue: "title")as! XMLNode)
                let chapterPageIndex = XMLElement.init(name: "int", stringValue: String(chapter.pageIndex))
                chapterPageIndex.addAttribute(XMLNode.attribute(withName: "pageIndex", stringValue: String(chapter.pageIndex))as! XMLNode)
                let chapterDic = XMLElement.init(name: "dict")
                chapterDic.addAttribute(XMLNode.attribute(withName: "name", stringValue: "chapter")as! XMLNode)
                chapterDic.addChild(chapterTitle)
                chapterDic.addChild(chapterPageIndex)
                
                chapters.append(chapterDic as! XMLNode)
            }
        }
        xmlDoc.rootElement()?.addChild(XMLNode.element(withName: "array", children: chapters, attributes: XMLNode.attribute(withName: "name", stringValue: "chapters") as? [XMLNode]) as! XMLNode)
        
        // bookType
        let bookType: String
        switch book.type {
        case .manga:
            bookType = "manga"
        case .comic:
            bookType = "comic"
        case .webManga:
            bookType = "webManga"
        }
        let bookTypeNode = XMLElement.init(name: "string", stringValue: bookType)
        bookTypeNode.addAttribute(XMLNode.attribute(withName: "name", stringValue: "type") as! XMLNode)
        xmlDoc.rootElement()?.addChild(bookTypeNode as XMLNode)
        
        if let readingMode = book.readingMode {
            let readingModeString: String
            switch readingMode {
            case .leftToRight:
                readingModeString = "leftToRight"
            case .rightToLeft:
                readingModeString = "rightToLeft"
            }
            let readingModeNode = XMLElement.init(name: "string", stringValue: readingModeString)
            readingModeNode.addAttribute(XMLNode.attribute(withName: "name", stringValue: "reading mode") as! XMLNode)
            xmlDoc.rootElement()?.addChild(readingModeNode as XMLNode)
        }
        
        xmlDoc.rootElement()?.addChild(safeElement(withName: "series", withProperty: book.seriesID))
        xmlDoc.rootElement()?.addChild(safeElement(withName: "seriesName", withProperty: book.seriesName))
        xmlDoc.rootElement()?.addChild(safeElement(withName: "rating", withProperty: book.rating))
        
        // lastUpdated
        var lastUpdated: String
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssv"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let lastUpdatedDate = book.lastUpdated {
            lastUpdated = RFC3339DateFormatter.string(from: lastUpdatedDate)
        } else {
            print("date nil")
            lastUpdated = "Unknown Release Date"
        }
        let lastupdateNode = XMLElement.init(name: "date", stringValue: lastUpdated)
        lastupdateNode.addAttribute(XMLNode.attribute(withName: "name", stringValue: "lastUpadate") as! XMLNode)
        let bookMarkNode = XMLElement.init(name: "int", stringValue: String(book.bookmark))
        bookMarkNode.addAttribute(XMLNode.attribute(withName: "name", stringValue: "bookmark") as! XMLNode)
        let cPageNode = XMLElement.init(name: "int", stringValue: String(book.currentPage))
        cPageNode.addAttribute(XMLNode.attribute(withName: "name", stringValue: "current page") as! XMLNode)
        let numOfBookNode = XMLElement.init(name: "int", stringValue: String(book.numberOfPages))
        numOfBookNode.addAttribute(XMLNode.attribute(withName: "name", stringValue: "number of pages") as! XMLNode)
        
        
        xmlDoc.rootElement()?.addChild(lastupdateNode as XMLNode)
        xmlDoc.rootElement()?.addChild(bookMarkNode as XMLNode)
        xmlDoc.rootElement()?.addChild(cPageNode as XMLNode)
        xmlDoc.rootElement()?.addChild(numOfBookNode as XMLNode)

        // XML version
        xmlDoc.version = "1.0"
        print(xmlDoc)
        // return the XMLDocument that has been assembled by the preceding code in this function
        return xmlDoc.xmlData(options:[.nodePrettyPrint, .nodeCompactEmptyElement])
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
}
