//
//  LocalPlugin.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 4/28/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class LocalPlugin: Plugin {
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
    
    func page(atIndex index: Int) -> LibraryPage {
        // some code
        return LibraryPage()
    }
    
    func book(withIdentifier identifier: Any) -> Book {
        // some code
        return Book(id: 4)
    }
}
