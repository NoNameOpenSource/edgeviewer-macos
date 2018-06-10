//
//  Chapter.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 4/16/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class Chapter {
    var title: String
    var pageIndex: Int
    
    init() {
        title = ""
        pageIndex = 0
    }
    
    init(title: String) {
        self.title = title
        pageIndex = 0
    }
    
    init(title: String, pageIndex: Int) {
        self.title = title
        self.pageIndex = pageIndex
    }
}
