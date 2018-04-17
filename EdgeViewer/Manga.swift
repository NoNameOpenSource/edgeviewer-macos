//
//  Manga.swift
//  EdgeViewer
//
//  Created by bmmkac on 4/3/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Cocoa

class Manga {
    var chapters : [Chapter] = [Chapter()]
    
    var Author : String = ""
    var title : String = ""
    var rating : Int = 0
    
    let coverImage : NSImage
    
    init(title : String) {
        self.title = title
        self.coverImage = NSImage()
        self.coverImage.backgroundColor = NSColor(calibratedRed: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    }
    
    func addNewPage(page : NSImage, chapterIndex : Int, pageIndex : Int?) {
        guard let pIndex = pageIndex else {
            self.chapters[chapterIndex].pages.append(page)
            return
        }
        self.chapters[chapterIndex].pages.insert(page, at: pIndex)
    }
    
    func addNewChapter() {
        chapters.append(Chapter())
    }
    
    func addNewChapters(howMany numNewChapters: Int) -> Int {
        for _ in 0..<numNewChapters {
            addNewChapter()
        }
        return chapters.count
    }
}



