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
    
    private static func createXMLDocumentData(book: Book) -> Data {
        // Set up XMLDocument element with new values
        
        // root element
        let xmlDoc = XMLDocument(rootElement: XMLElement(name: "book"))
        
        xmlDoc.rootElement()?.addChild(XMLNode.element(withName: "title", stringValue: book.title) as! XMLNode)
        xmlDoc.rootElement()?.addChild(safeElement(withName: "author", withProperty: book.author))
        xmlDoc.rootElement()?.addChild(safeElement(withName: "genre", withProperty: book.genre))
        
        // chapters
        var chapters = [XMLNode]()
        if book.chapters != nil {
            for chapter in book.chapters! {
                let chapterTitle = XMLNode.element(withName: "title", stringValue: chapter.title)
                let chapterPageIndex = XMLNode.element(withName: "pageIndex", stringValue: String(chapter.pageIndex))
                chapters.append(XMLNode.element(withName: "chapter", children: [chapterTitle as! XMLNode, chapterPageIndex as! XMLNode], attributes: nil) as! XMLNode)
            }
        }
        xmlDoc.rootElement()?.addChild(XMLNode.element(withName: "chapters", children: chapters, attributes: nil) as! XMLNode)
        
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
        xmlDoc.rootElement()?.addChild(XMLNode.element(withName: "type", stringValue: bookType) as! XMLNode)
        
        xmlDoc.rootElement()?.addChild(safeElement(withName: "series", withProperty: book.series))
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
        xmlDoc.rootElement()?.addChild(XMLNode.element(withName: "lastUpdated", stringValue: lastUpdated) as! XMLNode)
        xmlDoc.rootElement()?.addChild(XMLNode.element(withName: "bookmark", stringValue: String(book.bookmark)) as! XMLNode)
        xmlDoc.rootElement()?.addChild(XMLNode.element(withName: "currentPage", stringValue: String(book.currentPage)) as! XMLNode)
        xmlDoc.rootElement()?.addChild(XMLNode.element(withName: "numberOfPages", stringValue: String(book.numberOfPages)) as! XMLNode)

        // XML version
        xmlDoc.version = "1.0"
        
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
