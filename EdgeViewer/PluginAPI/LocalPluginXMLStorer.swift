//
//  LocalPluginStorer.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 5/14/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Foundation

class LocalPluginXMLStorer {
    
    var book: Book
    
    init(book: Book) {
        self.book = book
        storeBookData()
    }
    
    private func storeBookData() {
        let bookDirectoryURL: URL? = LocalPlugin.getApplicationSupportDirectory()?.appendingPathComponent("EdgeViewer/Books/\(book.title)")
        // Create Book directory in user's Application Support directory
        do {
            try FileManager.default.createDirectory(at: bookDirectoryURL!, withIntermediateDirectories: true)
        }
        catch {
            print("Could not create directory: \(error)")
        }
        
        if let xmlDocumentLocation: URL = bookDirectoryURL?.appendingPathComponent("BookData.xml") {
            
            let xmlDataString = getXMLDocumentData()
            
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
    
    private func getXMLDocumentData() -> Data {
        // Set up XMLDocument element with new values
        let xmlDoc = XMLDocument(rootElement: XMLElement(name: "book"))
        
        xmlDoc.rootElement()?.addChild(XMLNode.element(withName: "identifier", stringValue: String(book.identifier as! Int)) as! XMLNode)
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
        
        xmlDoc.rootElement()?.addChild(XMLNode.element(withName: "series", stringValue: String(book.series as! Int)) as! XMLNode)
        xmlDoc.rootElement()?.addChild(safeElement(withName: "seriesName", withProperty: book.seriesName))
        xmlDoc.rootElement()?.addChild(safeElement(withName: "rating", withProperty: book.rating))
        
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

        xmlDoc.version = "1.0"
        return xmlDoc.xmlData(options:[.nodePrettyPrint, .nodeCompactEmptyElement])
    }
    
    private func safeElement(withName elName: String, withProperty prop: Any?) -> XMLNode {
        var value = ""
        if let prop = prop {
            switch prop {
                case let prop as Double:
                    value = String(prop)
                case let prop as String:
                    value = prop
                default:
                    print("help me")
            }
        }
        return XMLNode.element(withName: elName, stringValue: value) as! XMLNode
    }
}
