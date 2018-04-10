//
//  Manga.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/3/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class Manga{
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
    var emptyPage : NSImage = NSImage(named: NSImage.Name(rawValue: "blank"))!

    
    init(Title : String) {
        self.title = Title
    }
    
    func addNewPage(Pages : NSImage){
        self.Page.append(Pages)
        self.PageNumber += 1
    }
    
    func grabPage () -> NSImage? {
       return self.Page[self.currentPage - 1] as NSImage
    }
    
    func grabRightPage() -> NSImage? {
        if self.currentPage == self.PageNumber{
            return self.emptyPage as NSImage
        }
        else {
            return self.Page[self.currentPage] as NSImage
        }
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
