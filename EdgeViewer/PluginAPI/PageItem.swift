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
    
    init(identifier: Any, type: PageItemType) {
        self.identifier = identifier
        self.type = type
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
