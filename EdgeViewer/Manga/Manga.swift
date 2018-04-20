//
//  Manga.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/3/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class Manga{
    var author : String = ""
    var pages : [NSImage] = []
    var numberOfPages : Int = 0
    var coverPage : NSImage = NSImage()
    var title : String = ""
    var rate : Int = 0
    var chapter : [Int] = [0]
    var emptyPage : NSImage = NSImage(named: NSImage.Name(rawValue: "blank"))!

    
    init(title: String) {
        self.title = title
    }
    
    func addNewPage(image : NSImage){
        self.pages.append(image)
        self.numberOfPages += 1
    }
}
