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
    //    var currentChapter : Int() {
    //  get
    //
    //}
    //set {
    //fuck you
    
    //}
    //}
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
    
    func addNewPage(Pages : NSImage){
        self.Page.append(Pages)
        self.PageNumber += 1
    }
    
    func grabPage () -> NSImage? {
        return self.Page[self.currentPage - 1] as NSImage
    }
    
    func IfNewChapter() -> Bool {
        var BeginOfChapter = false
        
        for Page in chapter {
            if currentPage == Page {
                BeginOfChapter = true
                break
            }
        }
        return BeginOfChapter
    }
}

