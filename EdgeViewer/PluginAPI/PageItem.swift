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
    
    var content: Any {
        get {
            print(self.identifier)
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
