//
//  Manga.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/3/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class Manga{
    //var chapter : [[NSImage]] = [[NSImage()]]
//    var currentChapter : Int() {
  //  get
    //
    //}
    //set {
     //fuck you
    
    //}
    //}
    var author : String = ""
    var page : [NSImage] = []
    var currentPage : Int = 1
    var pageNumber : Int = 0
    var coverPage : NSImage = NSImage()
    var title : String = ""
    var rate : Int = 0
    var chapter : [Int] = [1]
    var emptyPage : NSImage = NSImage(named: NSImage.Name(rawValue: "blank"))!

    
    init(title: String) {
        self.title = title
    }
    
    func addNewPage(Pages : NSImage){
        self.page.append(Pages)
        self.pageNumber += 1
    }
    
    func grabPage () -> NSImage? {
       return self.page[self.currentPage - 1] as NSImage
    }
    
    func grabRightPage() -> NSImage? {
        if self.currentPage == self.pageNumber{
            return self.emptyPage as NSImage
        }
        else {
            return self.page[self.currentPage] as NSImage
        }
    }
    
    func ifNewChapter() -> Bool {
        var beginOfChapter = false
        
        for Page in chapter {
            if currentPage == Page {
                beginOfChapter = true
                break
            }
        }
        return beginOfChapter
    }
}
