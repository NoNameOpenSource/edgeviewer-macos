//
//  Chapter.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 9/17/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class Series {
    var title: String
    var author: String?
    var rating: Double?
    var genre: String?
    var coverImage: NSImage
    var lastUpdated: Date?
    var identifier: Any
    var books: [Book]? {
        if let books = LocalPlugin.sharedInstance.books(ofSeries: self) {
            return books
        }
        else {
            print("could not get an array of books in the series \(title)")
            return nil
        }
    }
    
    init(owner: Plugin, identifier: Any) {
        title = ""
        coverImage = NSImage()
        self.identifier = identifier
    }
}
