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
        let bookDirectoryURL: URL? = getApplicationSupportDirectory()?.appendingPathComponent("EdgeViewer/Books/\(book.title)")
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
    
    private func getApplicationSupportDirectory() -> NSURL? {
        let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        if paths.count >= 1 {
            return NSURL(fileURLWithPath: paths[0], isDirectory: true)
        }
        print("Could not find application support directory.")
        return nil
    }
    
    private func getXMLDocumentData() -> Data {
        // Set up XMLDocument element with new values
        let xmlDoc = XMLDocument(rootElement: XMLElement(name: "book"))
        var elements = [XMLNode]()
        //elements.append(XMLNode.element(withName: "id", stringValue: String(book.id)) as! XMLNode)
        elements.append(XMLNode.element(withName: "title", stringValue: book.title) as! XMLNode)
        elements.append(XMLNode.element(withName: "release", stringValue: String(book.release)) as! XMLNode)
        elements.append(XMLNode.element(withName: "seriesName", stringValue: book.seriesName) as! XMLNode)
        elements.append(XMLNode.element(withName: "numPages", stringValue: String(book.numPages)) as! XMLNode)
        elements.append(XMLNode.element(withName: "bookmark", stringValue: String(book.bookmark)) as! XMLNode)
        //elements.append(XMLNode.element(withName: "chapters", stringValue: book.chapters) as! XMLNode)
        elements.append(XMLNode.element(withName: "author", stringValue: book.author) as! XMLNode)
        elements.append(XMLNode.element(withName: "genre", stringValue: book.genre) as! XMLNode)
        elements.append(XMLNode.element(withName: "progress", stringValue: String(book.progress)) as! XMLNode)
        elements.append(XMLNode.element(withName: "currentPage", stringValue: String(book.currentPage)) as! XMLNode)
        elements.append(XMLNode.element(withName: "pageNumber", stringValue: String(book.numPages)) as! XMLNode)
        elements.append(XMLNode.element(withName: "rating", stringValue: String(book.rating)) as! XMLNode)
        elements.append(XMLNode.element(withName: "lastUpdated", stringValue: getDateAsString()) as! XMLNode)
        //elements.append(XMLNode.element(withName: "coverImage", stringValue: book.coverImage) as! XMLNode)
        //elements.append(XMLNode.element(withName: "cover", stringValue: book.cover) as! XMLNode)
        elements.append(XMLNode.element(withName: "type", stringValue: getTypeAsString()) as! XMLNode)
        let newBook: XMLNode = XMLNode.element(withName: "book", children: elements, attributes: [XMLNode]()) as! XMLNode
        xmlDoc.rootElement()?.addChild(newBook)
        xmlDoc.version = "1.0"
        return xmlDoc.xmlData(options:[.nodePrettyPrint, .nodeCompactEmptyElement])
    }
    
    private func getDateAsString() -> String {
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let lastUpdatedDate = book.lastUpdated {
            return RFC3339DateFormatter.string(from: lastUpdatedDate)
        } else {
            print("date nil")
            return "Unknown Release Date"
        }
    }
    
    private func getTypeAsString() -> String {
        switch book.type {
        case .manga:
            return "manga"
        case .comic:
            return "comic"
        case .webManga:
            return "webManga"
        }
    }
}
