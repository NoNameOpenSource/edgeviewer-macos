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
    var currentPage : Int = 1
    var numberOfPages : Int = 0
    var coverPage : NSImage = NSImage()
    var title : String = ""
    var rate : Int = 0
    var chapter : [Int] = [1]
    var emptyPage : NSImage = NSImage(named: NSImage.Name(rawValue: "blank"))!

    
    init(title: String) {
        self.title = title
    }
    
    func addNewPage(Pages : NSImage){
        self.pages.append(Pages)
        self.numberOfPages += 1
    }
    
    func grabPage () -> NSImage? {
       return self.pages[self.currentPage - 1] as NSImage
    }
    
    func grabRightPage() -> NSImage? {
        if self.currentPage == self.numberOfPages{
            return self.emptyPage as NSImage
        }
        else {
            return self.pages[self.currentPage] as NSImage
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
