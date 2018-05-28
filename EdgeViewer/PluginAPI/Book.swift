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

class Book {
    
    let owner: Plugin

    var identifier: Any

    var title: String
    var author: String?
    var genre: String?
    var coverImage : NSImage
    var chapters: [Chapter]?
    var type: BookType

    var series: Any?
    var seriesName: String?

    var rating : Int?
    var lastUpdated: Date?
    
    var bookmark: Int // should be manually updated by user
    var currentPage: Int // should be automatically updated by UI

    var numberOfPages: Int
    
    init(owner: Plugin, identifier: Any, type: BookType) {
        self.owner = owner
        self.identifier = identifier
        self.type = type
    }
    
    func page(atIndex index: Int) -> NSImage? {
        return owner.page(ofBook: self, pageNumber: index)
    }

    var progress: Double {
		get {
			return Double(currentPage) / Double(pageNumber)
		}
	}
}