//
//  Manga.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/3/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class Manga {
    var Chapter : [[NSImage]] = [[NSImage()]]
    var Author : String = ""
    var Page : [NSImage] = []
    var currentPage : Int = 1
    var PageNumber : Int = 0
    var CoverPage : NSImage = NSImage()
    var title : String = ""
    var rate : Int = 0
    var chapter : [Int] = [1]
    let cover : NSImage
    
    init(Title : String) {
        self.title = Title
        self.cover = NSImage()
        self.cover.backgroundColor = NSColor(calibratedRed: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    }
}

