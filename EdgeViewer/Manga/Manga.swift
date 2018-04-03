//
//  Manga.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/3/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class Manga{
    var Page : [NSImage] = [NSImage()]
    var currentPage : Int = 1
    var PageNumber : Int = 0
    var CoverPage : NSImage = NSImage()
    var title : String = ""
    var rate : Int = 0
}
