//
//  Book.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 5. 4..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Cocoa

class Book {
    
    let owner: Plugin
    var title: String = ""
    var author: String?
    var series: Any?
    var seriesName: String?
    var identifier: Any
    var numberOfPages: Int = 0
    var chapters: [Chapter]?
    
    
    init(owner: Plugin, identifier: Any) {
        self.owner = owner;
        self.identifier = identifier
    }
    
    func page(atIndex index: Int) -> NSImage? {
        return owner.page(ofBook: self, pageNumber: index)
    }
}

