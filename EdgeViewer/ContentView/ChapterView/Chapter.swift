//
//  Chapter.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 4/16/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class Chapter {
    var title : String
    var coverImage : NSImage = NSImage()
    var pages : [NSImage] = [NSImage()]
    
    init() {
        title = ""
        coverImage = NSImage()
        pages = [NSImage()]
    }
    
    init(title : String) {
        self.title = title
        coverImage = NSImage()
        pages = [NSImage()]
    }
}
