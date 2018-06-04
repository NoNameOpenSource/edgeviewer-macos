//
//  LibraryPage.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 5. 4..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Foundation

enum LibraryPageType {
    case regular
    case loginPage
}

class LibraryPage {
    let identifier: Any
    let type: LibraryPageType
    let owner: Plugin
    var items: [PageItem] = [PageItem]()
    
    init(owner: Plugin, identifier: Any, type: LibraryPageType) {
        self.owner = owner
        self.identifier = identifier
        self.type = type
    }
    
    static func LibraryPageType(fromString type: String) -> LibraryPageType {
        switch type {
        case "regular":
            return .regular
        default:
            return .regular
        }
    }
}
