//
//  LocalPlugin.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 4/28/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class LocalPlugin: Plugin {
    
    static var sharedInstance = LocalPlugin()
    
    func page(withIdentifier identifier: Any) -> LibraryPage? {
        return LibraryPage(identifier: 5, type: .regular)
    }
    
    func book(withIdentifier identifier: Any) -> Book? {
        return Book(owner: self, identifier: 5, type: .manga)
    }
    
    func page(ofBook book: Book, pageNumber: Int) -> NSImage? {
        return NSImage()
    }
    
    func page(atIndex index: Int) -> NSImage {
        return NSImage()
    }
    
    func pages() -> [NSImage] {
        return [NSImage()]
    }
    
    var name: String = "Local"
    var version: Double = 0.1
    
    var books = [Book]()
    
    func addBook() {
        // some code
    }
}
