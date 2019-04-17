//
//  Book.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 5. 4..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Cocoa

enum BookType {
    case manga
    case comic
    case webManga
}

enum ReadingMode {
    case leftToRight
    case rightToLeft
}

class Book {
    
    let owner: Plugin

    var identifier: Any

    var title: String
    var author: String?
    var genre: String?
    var coverImage : NSImage
    var chapters: [Chapter]?
    var type: BookType
    var readingMode: ReadingMode?
    
    var series: Series? {
        get {
            if let seriesID = seriesID {
                return owner.series(withIdentifier: seriesID)
            } else {
                return nil
            }
        }
    }

    var seriesID: Any?
    var seriesName: String?

    var rating : Double?
    var lastUpdated: Date?
    
    var bookmark: Int // should be manually updated by user
    var currentPage: Int // should be automatically updated by UI

    var numberOfPages: Int
    
    init(owner: Plugin, identifier: Any, type: BookType) {
        self.owner = owner
        self.identifier = identifier
        self.type = type
        title = String()
        coverImage = NSImage()
        bookmark = Int()
        currentPage = Int()
        numberOfPages = Int()
    }
    
    func page(atIndex index: Int) -> NSImage? {
        return owner.page(ofBook: self, pageNumber: index)
    }

    var progress: Double {
		get {
			return Double(currentPage) / Double(numberOfPages)
		}
	}
    
    static func ==(left: Book, right: Book) -> Bool {
        return left.owner.isSameBook(left, right)
    }
}
