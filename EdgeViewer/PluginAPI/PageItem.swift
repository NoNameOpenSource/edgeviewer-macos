//
//  PageItem.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 6. 4..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Cocoa

enum PageItemType {
    case book
    case series
    case link
}

class PageItem {
    let owner: Plugin
    let identifier: Any
    let type: PageItemType
    var thumbnailURL: String?
    var name = ""
    var thumbnail: NSImage? {
        get {
            guard let thumbnailURL = thumbnailURL else {
                return nil
            }
            guard let url = URL(string: thumbnailURL) else {
                return nil
            }
            return NSImage(contentsOf: url)
        }
    }
    
    private var _content: Any?
    
    var content: Any {
        get {
            if let content = _content {
                return content
            }
            return self.owner.series(withIdentifier: self.identifier)
        }
    }
    
    init(owner: Plugin, identifier: Any, type: PageItemType) {
        self.owner = owner
        self.identifier = identifier
        self.type = type
    }
    
    init(owner: Plugin, book: Book) {
        self.owner = owner
        self.type = .book
        self.identifier = book.identifier
        self.name = book.title
        self._content = book
    }
    
    init(owner: Plugin, series: Series) {
        self.owner = owner
        self.type = .series
        self.identifier = series.identifier
        self.name = series.title
        self._content = series
    }
    
    static func PageItemType(fromString type: String) -> PageItemType {
        switch type {
            case "book":
                return .book
            case "link":
                return .link
            default:
                return .book
        }
    }
}
